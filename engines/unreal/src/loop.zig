//! Unreal's game thread, through `ProcessEvent`. The game calls it many times a frame on its game
//! thread, for Blueprints, widgets and events, so the first call after each Wraith frame ticks
//! Wraith there. That's where engine calls are safe, like other UFunctions through `call`.

const std = @import("std");
const sdk = @import("wraith_sdk");

const ProcessEventFn = @import("ue/process_event.zig").ProcessEventFn;
const object_name = @import("ue/objects.zig").object.name;

const log = sdk.log.scoped(.unreal);

pub const Loop = struct {
    hook: ?sdk.hooks.FnHook(ProcessEventFn) = null,
    /// Runs once a tick on the game thread.
    on_tick: ?Callback = null,
    /// Counted on the render thread.
    frames: sdk.atomic.Value(u64) = .init(0),
    /// Game thread only.
    ticked_frame: u64 = 0,
    ticking: bool = false,
    /// 0 till it's worked out.
    game_thread: sdk.atomic.Value(u32) = .init(0),
    votes: Votes = .{},
    votes_lock: sdk.sync.RwLock = .{},
    /// Run after the game calls these UFunctions, with their object and params. Set before `start`.
    watches: std.ArrayList(After) = .empty,
    /// The game's window shape, from the render thread, as f32 bits.
    aspect: sdk.atomic.Value(u32) = .init(@bitCast(@as(f32, 16.0 / 9.0))),
    /// `farewell`'s, run once on the game thread.
    leaving: ?Callback = null,
    leave: sdk.atomic.Value(bool) = .init(false),
    left: sdk.atomic.Value(bool) = .init(false),

    pub const Callback = struct {
        context: *anyopaque,
        func: *const fn (*anyopaque) void,
    };

    /// By the function's name, so Blueprints overriding it count too.
    pub const After = struct {
        name: u32,
        context: *anyopaque,
        func: *const fn (*anyopaque, object: usize, params: ?*anyopaque) void,
    };

    /// Before `start`. `function` is the UFunction, whose name's matched.
    pub fn watch(self: *Loop, function: usize, context: *anyopaque, func: *const fn (*anyopaque, object: usize, params: ?*anyopaque) void) void {
        self.watches.append(std.heap.smp_allocator, .{ .name = nameIndex(function), .context = context, .func = func }) catch
            log.warn("Out of memory, so something won't hear about its UFunction being called", .{});
    }

    /// A live UFunction's name, read straight, since the game's just handed it over.
    fn nameIndex(function: usize) u32 {
        return @as(*const u32, @ptrFromInt(function + object_name)).*;
    }

    /// Calls to vote on before picking the busiest thread.
    const vote_calls = 512;

    const Votes = struct {
        ids: [8]u32 = @splat(0),
        counts: [8]u32 = @splat(0),
        total: u32 = 0,

        /// The busiest thread once there've been enough calls.
        fn add(self: *Votes, id: u32) ?u32 {
            for (&self.ids, &self.counts) |*i, *c| {
                if (i.* == id or i.* == 0) {
                    i.* = id;
                    c.* += 1;
                    break;
                }
            }
            self.total += 1;
            if (self.total < vote_calls) return null;
            const best = std.mem.indexOfMax(u32, &self.counts);
            return self.ids[best];
        }
    };

    pub fn start(self: *Loop, process_event: usize, on_tick: Callback) !void {
        self.on_tick = on_tick;
        self.hook = try sdk.hooks.createFnWith(ProcessEventFn, process_event, onProcessEvent, self, .{ .enabled = true });
    }

    pub fn stop(self: *Loop) void {
        if (self.hook) |h| h.destroy();
        self.hook = null;
        // Only once the hook's gone, since its calls read them
        self.watches.deinit(std.heap.smp_allocator);
        self.watches = .empty;
    }

    /// Runs `cb` on the game thread before the hook goes, so the game can be put back how it was.
    /// Waits a little for the game to call in, and gives up if it doesn't, like while it's loading.
    pub fn farewell(self: *Loop, io: std.Io, cb: Callback) void {
        if (self.hook == null or self.game_thread.load(.acquire) == 0) return;
        if (self.onGameThread()) return cb.func(cb.context);
        self.leaving = cb;
        self.left.store(false, .release);
        self.leave.store(true, .release);
        var waited: usize = 0;
        while (!self.left.load(.acquire) and waited < 50) : (waited += 1) {
            io.sleep(.fromMilliseconds(10), .awake) catch break;
        }
        if (self.leave.swap(false, .acq_rel)) {
            log.warn("The game thread didn't come round, so the game might not be put back exactly as it was", .{});
            return;
        }
        // It took it just now, so it's running it
        while (!self.left.load(.acquire)) std.atomic.spinLoopHint();
    }

    /// Render thread, once a frame.
    pub fn frame(self: *Loop) void {
        _ = self.frames.fetchAdd(1, .release);
        const size = sdk.ui.getDisplaySize();
        if (size[0] > 0 and size[1] > 0) self.aspect.store(@bitCast(size[0] / size[1]), .release);
    }

    pub fn aspectRatio(self: *const Loop) f32 {
        return @bitCast(self.aspect.load(.acquire));
    }

    pub fn onGameThread(self: *const Loop) bool {
        const id = self.game_thread.load(.acquire);
        return id != 0 and id == std.Thread.getCurrentId();
    }

    /// Game thread only, like from a tick.
    pub fn call(self: *Loop, object: usize, function: usize, params: []u8) void {
        const h = self.hook orelse return;
        h.original()(object, function, params.ptr);
    }

    fn onProcessEvent(self: *Loop, h: sdk.hooks.FnHook(ProcessEventFn), object: usize, function: usize, params: ?*anyopaque) void {
        self.maybeTick();
        h.original()(object, function, params);
        if (self.watches.items.len == 0) return;
        const name = nameIndex(function);
        for (self.watches.items) |w| if (w.name == name) w.func(w.context, object, params);
    }

    fn maybeTick(self: *Loop) void {
        const id = std.Thread.getCurrentId();
        const game = self.game_thread.load(.acquire);
        if (game == 0) {
            self.votes_lock.lock();
            defer self.votes_lock.unlock();
            if (self.game_thread.load(.acquire) != 0) return;
            if (self.votes.add(id)) |picked| {
                self.game_thread.store(picked, .release);
                log.info("The game thread is {d}, which ticks Wraith now", .{picked});
            }
            return;
        }
        if (id != game or self.ticking) return;
        if (self.leave.load(.acquire)) {
            if (self.leave.swap(false, .acq_rel)) {
                if (self.leaving) |cb| cb.func(cb.context);
                self.left.store(true, .release);
            }
            return;
        }
        const f = self.frames.load(.acquire);
        if (f == self.ticked_frame) return;
        self.ticked_frame = f;
        self.ticking = true;
        defer self.ticking = false;
        if (self.on_tick) |cb| cb.func(cb.context);
    }
};

test "the busiest thread wins" {
    var votes: Loop.Votes = .{};
    var picked: ?u32 = null;
    for (0..Loop.vote_calls) |i| picked = votes.add(if (i % 4 == 0) 7 else 3);
    try std.testing.expectEqual(3, picked.?);
}
