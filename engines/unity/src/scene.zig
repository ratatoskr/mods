//! Unity's `FindObjectsOfType`, cached. Finding every object of a type means Unity looks through
//! everything it has, so each type's answer is kept for about a second, and Unity's main thread asks
//! again, one type a frame, only for types someone's asked about lately. What's handed out is
//! checked first, so nothing Unity's destroyed since gets through.
//!
//! What it finds is held through the game's runtime till the next answer, so the garbage collector
//! doesn't take them. Unity can still destroy them, which zeroes their native pointer, so check with
//! `alive`, a plain memory read, before using one on a later frame. Hold one yourself to keep it
//! past the next answer.

const std = @import("std");
const sdk = @import("wraith_sdk");

const engine_ = @import("engine.zig");
const Engine = engine_.Engine;
const Object = engine_.Object;

const W = sdk.api.wraith;
const Vec3 = sdk.math.Vec3;
const gpa = std.heap.smp_allocator;
const word = @sizeOf(usize);
const array_length = 3 * word;
const array_items = 4 * word;

/// Asked again once it's this many frames old, about a second
const fresh_frames = 60;
/// Not asked again once nobody's wanted it for this many frames
const idle_frames = 120;
/// Of one type
const max_objects = 4096;

/// For the Timings window
var zone_ask: sdk.timing.Zone = .init("Scene: asking Unity");

pub const Name = struct {
    buf: [48]u8 = undefined,
    len: u8 = 0,

    pub fn init(s: []const u8) Name {
        var n: Name = .{ .len = @intCast(@min(s.len, 48)) };
        @memcpy(n.buf[0..n.len], s[0..n.len]);
        return n;
    }

    pub fn get(n: *const Name) []const u8 {
        return n.buf[0..n.len];
    }
};

/// A component, and where it is.
pub const Found = struct {
    object: *Object,
    native: usize,
    transform: *Object,
    transform_native: usize,
    /// Its GameObject's
    name: Name,
    /// As of when Unity was last asked
    position: Vec3,
    /// Holds on the object and its Transform, till the next answer
    holds: [2]u32 = .{ 0, 0 },
};

const Calls = struct {
    find_objects: *const fn (?*Object, bool) callconv(.c) ?*Object,
    name: *const fn (*Object) callconv(.c) ?*Object,

    const names = .{
        .find_objects = .{ "UnityEngine.Object", "FindObjectsOfType" },
        .name = .{ "UnityEngine.Object", "GetName" },
    };
};

/// One type's answer.
const Cached = struct {
    class: []u8,
    type_object: usize,
    found: std.ArrayList(Found) = .empty,
    /// Frames, by `Scene.frame`. `asked` from any thread.
    refreshed: ?u32 = null,
    /// Counts Unity's answers
    answer: u32 = 0,
    asked: sdk.atomic.Value(u32) = .init(0),
};

pub const Scene = struct {
    managed: W.Managed,
    engine: *const Engine,
    calls: Calls,
    /// Where `UnityEngine.Object` keeps its native object
    cached_ptr: usize,

    /// Over `types` and what's in them
    lock: sdk.sync.RwLock = .{},
    types: std.ArrayList(*Cached) = .empty,
    frame: sdk.atomic.Value(u32) = .init(0),
    // Main thread only from here down
    /// Asking Unity makes a string each time, so names are kept, by native object
    names: std.AutoHashMapUnmanaged(usize, Name) = .empty,
    /// Which type to look at first next frame, so they take turns
    turn: usize = 0,

    /// Blocks while the game's runtime looks, so not on the render thread.
    pub fn init(engine: *const Engine, managed: W.Managed, missing: *[]const u8) !Scene {
        sdk.timing.list(&zone_ask);
        return .{
            .managed = managed,
            .engine = engine,
            .calls = try engine_.findCalls(Calls, Calls.names, managed, missing),
            .cached_ptr = try managed.fieldOffset("UnityEngine.Object", "m_CachedPtr"),
        };
    }

    pub fn deinit(self: *Scene) void {
        for (self.types.items) |c| {
            self.release(c.found.items);
            c.found.deinit(gpa);
            gpa.free(c.class);
            gpa.destroy(c);
        }
        self.types.deinit(gpa);
        self.names.deinit(gpa);
    }

    /// Still the object it was, and not destroyed. Any thread.
    pub fn alive(self: *const Scene, object: *Object, native: usize) bool {
        return native != 0 and self.nativeOf(object) == native;
    }

    /// A plain read, which is safe as long as the object's held or has only just come from Unity.
    /// Asking Windows if it's readable first is far too slow for every bone every frame.
    pub fn nativeOf(self: *const Scene, object: *Object) usize {
        const at: *const usize = @ptrFromInt(@intFromPtr(object) + self.cached_ptr);
        return at.*;
    }

    /// Every component of `class`, like `UnityEngine.Animator`, as of Unity's last answer, into
    /// `out`, leaving out what's been destroyed since. The first ask for a type comes back empty,
    /// till the main thread's asked Unity. Any thread, though a new type waits on the game's runtime.
    /// Gives which of Unity's answers it was, 0 for none yet, so callers can tell when it's new.
    pub fn objectsOfType(self: *Scene, a: std.mem.Allocator, class: []const u8, out: *std.ArrayList(Found)) !u32 {
        const c = try self.cached(class);
        c.asked.store(self.frame.load(.monotonic), .monotonic);
        self.lock.lockShared();
        defer self.lock.unlockShared();
        for (c.found.items) |f| {
            if (!self.alive(f.object, f.native) or !self.alive(f.transform, f.transform_native)) continue;
            try out.append(a, f);
        }
        return c.answer;
    }

    fn cached(self: *Scene, class: []const u8) !*Cached {
        {
            self.lock.lockShared();
            defer self.lock.unlockShared();
            for (self.types.items) |c| if (std.mem.eql(u8, c.class, class)) return c;
        }
        const type_object = self.managed.typeObject(class) catch return error.NotFound;
        self.lock.lock();
        defer self.lock.unlock();
        // Someone else might have got there first
        for (self.types.items) |c| if (std.mem.eql(u8, c.class, class)) return c;
        const c = try gpa.create(Cached);
        errdefer gpa.destroy(c);
        c.* = .{ .class = try gpa.dupe(u8, class), .type_object = type_object };
        errdefer gpa.free(c.class);
        try self.types.append(gpa, c);
        return c;
    }

    /// Main thread, once a frame. Asks Unity about one type that's due.
    pub fn tick(self: *Scene) void {
        const f = self.frame.fetchAdd(1, .monotonic) +% 1;
        const due = blk: {
            self.lock.lockShared();
            defer self.lock.unlockShared();
            const n = self.types.items.len;
            for (0..n) |i| {
                const c = self.types.items[(self.turn + i) % n];
                if (f -% c.asked.load(.monotonic) > idle_frames) continue;
                if (c.refreshed) |r| if (f -% r < fresh_frames) continue;
                self.turn = (self.turn + i + 1) % n;
                break :blk c;
            }
            break :blk null;
        };
        if (due) |c| self.refresh(c, f);
    }

    fn refresh(self: *Scene, c: *Cached, f: u32) void {
        const z = zone_ask.begin();
        defer z.end();
        var found: std.ArrayList(Found) = .empty;
        // On the stack, where the garbage collector sees it, and what's in it through it
        if (self.calls.find_objects(@ptrFromInt(c.type_object), false)) |array| {
            // Unity's just made it, so it's there to read plainly
            const n = @min(@as(*align(1) const usize, @ptrFromInt(@intFromPtr(array) + array_length)).*, max_objects);
            const items: [*]const ?*Object = @ptrFromInt(@intFromPtr(array) + array_items);
            found.ensureTotalCapacity(gpa, n) catch {};
            for (items[0..n]) |item| {
                const object = item orelse continue;
                const transform = self.engine.transform(object) orelse continue;
                var position: Vec3 = .{};
                self.engine.get_position(transform, &position);
                const transform_native = self.nativeOf(transform);
                // Held before anything else can make garbage and set the collector off
                const holds: [2]u32 = .{ self.managed.hold(@intFromPtr(object)) catch 0, self.managed.hold(@intFromPtr(transform)) catch 0 };
                found.append(gpa, .{
                    .object = object,
                    .native = self.nativeOf(object),
                    .transform = transform,
                    .transform_native = transform_native,
                    .name = self.nameOf(object, transform_native),
                    .position = position,
                    .holds = holds,
                }) catch {
                    for (holds) |h| if (h != 0) self.managed.release(h);
                    break;
                };
            }
        }
        self.lock.lock();
        std.mem.swap(std.ArrayList(Found), &c.found, &found);
        c.refreshed = f;
        c.answer +%= 1;
        if (c.answer == 0) c.answer = 1;
        self.lock.unlock();
        // The last answer's, now nobody can be reading them
        self.release(found.items);
        found.deinit(gpa);
        // Names of what's gone, now and then
        if (self.names.count() > 4 * max_objects) self.names.clearRetainingCapacity();
    }

    fn release(self: *Scene, found: []const Found) void {
        for (found) |f| for (f.holds) |h| if (h != 0) self.managed.release(h);
    }

    /// Main thread, once its GameObject's been renamed, so what's handed out says so before Unity's
    /// next answer. `object_native` is the component's, `transform_native` what its name's kept by.
    pub fn rename(self: *Scene, object_native: usize, transform_native: usize, name: []const u8) void {
        const n: Name = .init(name);
        self.names.put(gpa, transform_native, n) catch {};
        self.lock.lock();
        defer self.lock.unlock();
        // Every component on it has its GameObject's name
        for (self.types.items) |c| for (c.found.items) |*f| {
            if (f.native == object_native or f.transform_native == transform_native) f.name = n;
        };
    }

    /// Main thread. `native` is what it's kept by.
    pub fn nameOf(self: *Scene, object: *Object, native: usize) Name {
        if (self.names.get(native)) |n| return n;
        var buf: [48]u8 = undefined;
        const name: Name = if (self.calls.name(object)) |s| .init(readString(@intFromPtr(s), &buf)) else .{};
        self.names.put(gpa, native, name) catch {};
        return name;
    }
};

/// A C# string, the same under Mono and IL2CPP: the header, its length, then UTF-16. Anything past
/// ASCII is `?`, which is fine for telling things apart. Plain reads, as it's one Unity's just made.
pub fn readString(at: usize, buf: []u8) []const u8 {
    const len: *align(1) const i32 = @ptrFromInt(at + 2 * word);
    const chars: [*]align(1) const u16 = @ptrFromInt(at + 2 * word + 4);
    const n = @min(@as(usize, @intCast(@max(len.*, 0))), buf.len);
    for (chars[0..n], buf[0..n]) |ch, *b| b.* = if (ch < 0x80) @intCast(ch) else '?';
    return buf[0..n];
}

const testing = std.testing;

test "strings read as ASCII" {
    const Str = extern struct { head: [2]usize = .{ 0, 0 }, len: i32, chars: [5]u16 };
    const s: Str = .{ .len = 5, .chars = .{ 'H', 'i', 'p', 0x263A, 's' } };
    var buf: [8]u8 = undefined;
    try testing.expectEqualStrings("Hip?s", readString(@intFromPtr(&s), &buf));
    var small: [2]u8 = undefined;
    try testing.expectEqualStrings("Hi", readString(@intFromPtr(&s), &small));
}
