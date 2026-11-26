//! The `Unreal` service from `schemas/unreal.sal`: objects, properties and functions by name, for
//! other plugins, Workbench scripts and tweaks. Game thread only, where every object in the
//! engine's array is alive, so objects are read plainly once they're known to be objects.

const std = @import("std");
const sdk = @import("wraith_sdk");
const generated = @import("schema");
const schema = generated.Unreal;

const Unreal = @import("ue/Unreal.zig");
const objects_ = @import("ue/objects.zig");
const Loop = @import("loop.zig").Loop;
const explorer = @import("explorer.zig");

const object = objects_.object;
const Value = schema.UnrealValue;
const Error = schema.UnrealError;
const gpa = std.heap.smp_allocator;

/// `RF_ClassDefaultObject` and `RF_ArchetypeObject`.
const template_flags = 0x10 | 0x20;
const max_params = 64 * 1024;
const max_fields = 4096;

pub const Service = struct {
    ue: *const Unreal = undefined,
    loop: *Loop = undefined,
    /// Once `ue` is found and the game thread's known.
    ready: sdk.atomic.Value(bool) = .init(false),

    pub fn start(self: *Service, ue: *const Unreal, loop: *Loop) void {
        self.ue = ue;
        self.loop = loop;
        self.ready.store(true, .release);
    }

    pub fn stop(self: *Service) void {
        self.ready.store(false, .release);
    }

    /// Unreal's there and this is its game thread.
    fn check(self: *Service) Error!*const Unreal {
        if (!self.ready.load(.acquire)) return fail(error.NotReady, "Unreal isn't found yet, or this game's missing what the plugin needs", .{});
        if (!self.loop.onGameThread()) return fail(error.WrongThread, "Unreal's objects can only be used on the game thread. Use threads.onTick, or a script on the game thread", .{});
        return self.ue;
    }

    /// Checked like `check`, and a live object.
    fn checkObject(self: *Service, obj: usize) Error!*const Unreal {
        const ue = try self.check();
        if (obj == 0 or !ue.objects.isObject(obj)) return fail(error.NotFound, "0x{x} isn't an object, or Unreal's collected it", .{obj});
        return ue;
    }

    pub fn findObjects(self: *Service, class_name: []const u8) Error![]const usize {
        const ue = try self.check();
        const a = answers.get();
        var out: std.ArrayList(usize) = .empty;
        var it = Matches.init(ue, class_name);
        defer it.deinit();
        while (it.next()) |obj| out.append(a, obj) catch return fail(error.NotFound, "Out of memory", .{});
        return out.items;
    }

    pub fn findObject(self: *Service, class_name: []const u8) Error!usize {
        const ue = try self.check();
        var it = Matches.init(ue, class_name);
        defer it.deinit();
        return it.next() orelse fail(error.NotFound, "There's no {s}", .{class_name});
    }

    pub fn defaultObject(self: *Service, class_name: []const u8) Error!usize {
        const ue = try self.check();
        var buf: [256]u8 = undefined;
        for (0..ue.objects.count()) |i| {
            const obj = ue.objects.getPlain(i);
            if (obj == 0 or plain(u32, obj + object.flags) & Unreal.class_default == 0) continue;
            const class = plain(usize, obj + object.class);
            if (std.mem.eql(u8, ue.nameOf(class, &buf) orelse continue, class_name)) return obj;
        }
        return fail(error.NotFound, "There's no class {s}", .{class_name});
    }

    pub fn isObject(self: *Service, obj: usize) bool {
        if (!self.ready.load(.acquire)) return false;
        return obj != 0 and self.ue.objects.isObject(obj);
    }

    pub fn nameOf(self: *Service, obj: usize) Error![]const u8 {
        const ue = try self.checkObject(obj);
        var buf: [256]u8 = undefined;
        return dupe(ue.nameOf(obj, &buf) orelse "");
    }

    pub fn classOf(self: *Service, obj: usize) Error![]const u8 {
        const ue = try self.checkObject(obj);
        var buf: [256]u8 = undefined;
        return dupe(ue.classNameOf(obj, &buf) orelse "");
    }

    pub fn pathOf(self: *Service, obj: usize) Error![]const u8 {
        const ue = try self.checkObject(obj);
        var buf: [1024]u8 = undefined;
        return dupe(ue.pathOf(obj, &buf) orelse "");
    }

    pub fn isA(self: *Service, obj: usize, class_name: []const u8) Error!bool {
        const ue = try self.checkObject(obj);
        return ue.isA(obj, class_name);
    }

    pub fn properties(self: *Service, obj: usize) Error![]const schema.UnrealProperty {
        const ue = try self.checkObject(obj);
        const a = answers.get();
        var chain: [64]usize = undefined;
        const supers = superChain(ue, ue.classOf(obj) orelse 0, &chain);
        var out: std.ArrayList(schema.UnrealProperty) = .empty;
        var buf: [256]u8 = undefined;
        var i = supers.len;
        while (i > 0) {
            i -= 1;
            var field = ue.firstField(supers[i]);
            var n: usize = 0;
            while (field) |f| : (field = ue.nextField(f)) {
                n += 1;
                if (n > max_fields) break;
                const kind = ue.fieldKind(f, &buf) orelse continue;
                if (!std.mem.endsWith(u8, kind, "Property")) continue;
                const p = ue.property(f) orelse continue;
                if (p.offset < 0) continue;
                const kind_copy = a.dupe(u8, kind) catch break;
                out.append(a, .{
                    .name = a.dupe(u8, ue.fieldName(f, &buf) orelse "?") catch break,
                    .type = kind_copy,
                    .offset = @intCast(p.offset),
                    .size = @intCast(@max(p.size, 0) * @max(p.count, 1)),
                }) catch break;
            }
        }
        return out.items;
    }

    pub fn address(self: *Service, obj: usize, name: []const u8) Error!usize {
        const ue = try self.checkObject(obj);
        const field = try propertyOf(ue, obj, name);
        const p = ue.property(field).?;
        return obj + @as(usize, @intCast(p.offset));
    }

    pub fn get(self: *Service, obj: usize, name: []const u8) Error!Value {
        const ue = try self.checkObject(obj);
        return read(ue, try propertyOf(ue, obj, name), obj, answers.get());
    }

    pub fn set(self: *Service, obj: usize, name: []const u8, value: Value) Error!void {
        const ue = try self.checkObject(obj);
        return write(ue, try propertyOf(ue, obj, name), obj, value);
    }

    pub fn call(self: *Service, obj: usize, name: []const u8, args: []const Value) Error!Value {
        const ue = try self.checkObject(obj);
        const class = ue.classOf(obj) orelse 0;
        const function = ue.functionNamed(class, name) orelse return fail(error.NotFound, "{s} has no function {s}", .{ className(ue, obj), name });
        const size: usize = @intCast(@max(ue.structSize(function) orelse 0, 0));
        if (size > max_params) return fail(error.WrongType, "{s}'s params are too big", .{name});
        const params = gpa.alignedAlloc(u8, .@"16", @max(size, 1)) catch return fail(error.NotFound, "Out of memory", .{});
        defer gpa.free(params);
        @memset(params, 0);
        const base = @intFromPtr(params.ptr);

        var buf: [256]u8 = undefined;
        var given: usize = 0;
        var returns: ?usize = null;
        var field = ue.firstField(function);
        var n: usize = 0;
        // Params come first, then a blueprint's locals, which it zeroes itself
        const count = numParams(ue, function) orelse max_fields;
        while (field) |f| : (field = ue.nextField(f)) {
            if (n == count) break;
            n += 1;
            if (std.mem.eql(u8, ue.fieldName(f, &buf) orelse "", "ReturnValue")) {
                returns = f;
                continue;
            }
            if (given == args.len) continue;
            try write(ue, f, base, args[given]);
            given += 1;
        }
        if (given < args.len) return fail(error.WrongType, "{s} takes {d} argument(s), not {d}", .{ name, given, args.len });
        self.loop.call(obj, function, params);
        const r = returns orelse return none;
        return read(ue, r, base, answers.get()) catch none;
    }

    pub fn location(self: *Service, actor: usize) Error!generated.Wraith.Vec3 {
        return self.vector(actor, "K2_GetActorLocation");
    }

    pub fn setLocation(self: *Service, actor: usize, at: generated.Wraith.Vec3) Error!void {
        return self.setVector(actor, "K2_SetActorLocation", "NewLocation", "bTeleport", at);
    }

    pub fn rotation(self: *Service, actor: usize) Error!generated.Wraith.Vec3 {
        return self.vector(actor, "K2_GetActorRotation");
    }

    pub fn setRotation(self: *Service, actor: usize, to: generated.Wraith.Vec3) Error!void {
        return self.setVector(actor, "K2_SetActorRotation", "NewRotation", "bTeleportPhysics", to);
    }

    fn vector(self: *Service, actor: usize, function: []const u8) Error!generated.Wraith.Vec3 {
        const v = try self.call(actor, function, &.{});
        if (v.kind != .floats or v.floats.len < 3) return fail(error.WrongType, "{s} didn't give a vector", .{function});
        return .{ .x = @floatCast(v.floats[0]), .y = @floatCast(v.floats[1]), .z = @floatCast(v.floats[2]) };
    }

    /// Through `function`, with `flag` set so it's straight there.
    fn setVector(self: *Service, actor: usize, function: []const u8, param: []const u8, flag: []const u8, v: generated.Wraith.Vec3) Error!void {
        const ue = try self.checkObject(actor);
        const class = ue.classOf(actor) orelse 0;
        const func = ue.functionNamed(class, function) orelse return fail(error.NotFound, "{s} has no function {s}", .{ className(ue, actor), function });
        const size: usize = @intCast(@max(ue.structSize(func) orelse 0, 0));
        if (size > max_params) return fail(error.WrongType, "{s}'s params are too big", .{function});
        const params = gpa.alignedAlloc(u8, .@"16", @max(size, 1)) catch return fail(error.NotFound, "Out of memory", .{});
        defer gpa.free(params);
        @memset(params, 0);
        const base = @intFromPtr(params.ptr);
        const at = ue.fieldNamed(func, param) orelse return fail(error.NotFound, "{s} has no {s}", .{ function, param });
        const floats = [3]f64{ v.x, v.y, v.z };
        try write(ue, at, base, .{ .kind = .floats, .flag = false, .integer = 0, .number = 0, .text = "", .object = 0, .floats = &floats });
        if (ue.fieldNamed(func, flag)) |f| try write(ue, f, base, .{ .kind = .flag, .flag = true, .integer = 0, .number = 0, .text = "", .object = 0, .floats = &.{} });
        self.loop.call(actor, func, params);
    }
};

const none: Value = .{ .kind = .none, .flag = false, .integer = 0, .number = 0, .text = "", .object = 0, .floats = &.{} };

fn fail(err: Error, comptime fmt: []const u8, args: anytype) Error {
    return sdk.api.salamander.host().explain(err, fmt, args);
}

/// Good till this thread asks again, by when salamander's copied it.
const answers = struct {
    threadlocal var arena: ?std.heap.ArenaAllocator = null;

    fn get() std.mem.Allocator {
        if (arena) |*a| {
            _ = a.reset(.retain_capacity);
        } else arena = .init(gpa);
        return arena.?.allocator();
    }
};

fn dupe(text: []const u8) []const u8 {
    return answers.get().dupe(u8, text) catch "";
}

fn plain(comptime T: type, at: usize) T {
    return @as(*align(1) const T, @ptrFromInt(at)).*;
}

fn className(ue: *const Unreal, obj: usize) []const u8 {
    const S = struct {
        threadlocal var buf: [256]u8 = undefined;
    };
    return ue.classNameOf(obj, &S.buf) orelse "It";
}

fn superChain(ue: *const Unreal, class: usize, chain: []usize) []usize {
    var n: usize = 0;
    var at: ?usize = if (class == 0) null else class;
    while (at) |c| : (at = ue.superOf(c)) {
        if (n == chain.len) break;
        chain[n] = c;
        n += 1;
    }
    return chain[0..n];
}

/// Its class's property `name`, or its supers'.
fn propertyOf(ue: *const Unreal, obj: usize, name: []const u8) Error!usize {
    var chain: [64]usize = undefined;
    for (superChain(ue, ue.classOf(obj) orelse 0, &chain)) |c| {
        const f = ue.fieldNamed(c, name) orelse continue;
        const p = ue.property(f) orelse continue;
        if (p.offset >= 0) return f;
    }
    return fail(error.NotFound, "{s} has no property {s}", .{ className(ue, obj), name });
}

/// A UFunction's `NumParms`, a byte after its flags. Its return value counts.
fn numParams(ue: *const Unreal, function: usize) ?usize {
    const flags = ue.functionFlagsOffset() orelse return null;
    return ue.mem.read(u8, function + flags + 4) orelse null;
}

/// Every live object that's a `class_name` or comes from one, class defaults left out.
const Matches = struct {
    ue: *const Unreal,
    name: []const u8,
    i: usize = 0,
    count: usize,
    /// Each class seen, and if it's one
    classes: std.AutoHashMapUnmanaged(usize, bool) = .empty,

    fn init(ue: *const Unreal, name: []const u8) Matches {
        return .{ .ue = ue, .name = name, .count = ue.objects.count() };
    }

    fn deinit(m: *Matches) void {
        m.classes.deinit(gpa);
    }

    fn next(m: *Matches) ?usize {
        while (m.i < m.count) {
            const obj = m.ue.objects.getPlain(m.i);
            m.i += 1;
            if (obj == 0 or plain(u32, obj + object.flags) & template_flags != 0) continue;
            if (m.matches(plain(usize, obj + object.class))) return obj;
        }
        return null;
    }

    fn matches(m: *Matches, class: usize) bool {
        if (m.classes.get(class)) |yes| return yes;
        var buf: [256]u8 = undefined;
        var chain: [64]usize = undefined;
        const yes = for (superChain(m.ue, class, &chain)) |c| {
            if (std.mem.eql(u8, m.ue.nameOf(c, &buf) orelse continue, m.name)) break true;
        } else false;
        m.classes.put(gpa, class, yes) catch {};
        return yes;
    }
};

/// What a property is, for reading and writing it.
const Slot = union(enum) {
    number: explorer.Kind,
    /// A byte or enum, by its size
    whole: u8,
    flag: struct { offset: usize, mask: u8 },
    name,
    string,
    object,
    weak,
    floats: struct { n: u8, elem: u8 },
};

fn slotOf(ue: *const Unreal, field: usize) Error!struct { slot: Slot, offset: usize } {
    var buf: [128]u8 = undefined;
    const kind = ue.fieldKind(field, &buf) orelse return fail(error.WrongType, "Can't read what kind of property it is", .{});
    const p = ue.property(field) orelse return fail(error.WrongType, "Can't read the property", .{});
    const offset: usize = @intCast(@max(p.offset, 0));
    const size: u8 = @intCast(@min(@max(p.size, 0), 255));
    const slot: Slot = if (explorer.plainKind(kind)) |k|
        .{ .number = k }
    else if (std.mem.eql(u8, kind, "BoolProperty")) blk: {
        const info = ue.mem.read([4]u8, field + ue.layout.property_end) orelse return fail(error.WrongType, "Can't read the bool's bit", .{});
        break :blk .{ .flag = .{ .offset = info[1], .mask = if (info[3] == 0) 0xFF else info[3] } };
    } else if (std.mem.eql(u8, kind, "ByteProperty") or std.mem.eql(u8, kind, "EnumProperty"))
        .{ .whole = size }
    else if (std.mem.eql(u8, kind, "NameProperty"))
        .name
    else if (std.mem.eql(u8, kind, "StrProperty"))
        .string
    else if (std.mem.eql(u8, kind, "ObjectProperty") or std.mem.eql(u8, kind, "ClassProperty") or std.mem.eql(u8, kind, "ObjectPtrProperty"))
        .object
    else if (std.mem.eql(u8, kind, "WeakObjectProperty"))
        .weak
    else if (std.mem.eql(u8, kind, "StructProperty")) blk: {
        var name_buf: [256]u8 = undefined;
        const strct = p.type orelse return fail(error.WrongType, "Can't read the struct's type", .{});
        const struct_name = ue.nameOf(strct, &name_buf) orelse "?";
        const f = explorer.floatsOf(struct_name, size) orelse return fail(error.WrongType, "It's a {s}, which isn't only floats. Use address and memory", .{struct_name});
        break :blk .{ .floats = .{ .n = f.n, .elem = f.elem } };
    } else return fail(error.WrongType, "It's a {s}. Use address and memory", .{kind});
    return .{ .slot = slot, .offset = offset };
}

/// `field` of what's at `base`, an object or a function's params.
fn read(ue: *const Unreal, field: usize, base: usize, a: std.mem.Allocator) Error!Value {
    const s = try slotOf(ue, field);
    const at = base + s.offset;
    var v = none;
    switch (s.slot) {
        .number => |k| switch (k) {
            .f32 => v = number(plain(f32, at)),
            .f64 => v = number(plain(f64, at)),
            .i8 => v = integer(plain(i8, at)),
            .u8 => v = integer(plain(u8, at)),
            .i16 => v = integer(plain(i16, at)),
            .u16 => v = integer(plain(u16, at)),
            .i32 => v = integer(plain(i32, at)),
            .u32 => v = integer(plain(u32, at)),
            else => v = integer(plain(i64, at)),
        },
        .whole => |size| v = integer(switch (size) {
            1 => plain(u8, at),
            2 => plain(u16, at),
            4 => plain(i32, at),
            else => plain(i64, at),
        }),
        .flag => |b| {
            v.kind = .flag;
            v.flag = plain(u8, at + b.offset) & b.mask != 0;
        },
        .name => {
            var buf: [256]u8 = undefined;
            v.kind = .text;
            v.text = a.dupe(u8, ue.fname(at, &buf) orelse "") catch "";
        },
        .string => {
            v.kind = .text;
            v.text = readString(ue, a, at);
        },
        .object => {
            v.kind = .object;
            v.object = plain(usize, at);
        },
        .weak => {
            v.kind = .object;
            const index = plain(i32, at);
            v.object = if (index >= 0) ue.objects.get(@intCast(index)) orelse 0 else 0;
        },
        .floats => |f| {
            const out = a.alloc(f64, f.n) catch return fail(error.WrongType, "Out of memory", .{});
            for (out, 0..) |*o, i| o.* = if (f.elem == 8) plain(f64, at + i * 8) else plain(f32, at + i * 4);
            v.kind = .floats;
            v.floats = out;
        },
    }
    return v;
}

fn write(ue: *const Unreal, field: usize, base: usize, v: Value) Error!void {
    const s = try slotOf(ue, field);
    const at = base + s.offset;
    switch (s.slot) {
        .number => |k| switch (k) {
            .f32 => put(f32, at, @floatCast(try asNumber(v))),
            .f64 => put(f64, at, try asNumber(v)),
            .i8, .u8 => put(u8, at, @truncate(@as(u64, @bitCast(try asInteger(v))))),
            .i16, .u16 => put(u16, at, @truncate(@as(u64, @bitCast(try asInteger(v))))),
            .i32, .u32 => put(u32, at, @truncate(@as(u64, @bitCast(try asInteger(v))))),
            else => put(i64, at, try asInteger(v)),
        },
        .whole => |size| {
            const bits: u64 = @bitCast(try asInteger(v));
            switch (size) {
                1 => put(u8, at, @truncate(bits)),
                2 => put(u16, at, @truncate(bits)),
                4 => put(u32, at, @truncate(bits)),
                else => put(u64, at, bits),
            }
        },
        .flag => |b| {
            const on = switch (v.kind) {
                .flag => v.flag,
                .integer => v.integer != 0,
                .number => v.number != 0,
                else => return wrongValue(v, "a bool"),
            };
            const byte = plain(u8, at + b.offset);
            put(u8, at + b.offset, if (on) byte | b.mask else byte & ~b.mask);
        },
        .object => put(usize, at, switch (v.kind) {
            .object => v.object,
            .integer => @truncate(@as(u64, @bitCast(v.integer))),
            .none => 0,
            else => return wrongValue(v, "an object"),
        }),
        .floats => |f| {
            if (v.kind != .floats or v.floats.len < f.n) return wrongValue(v, "floats");
            for (v.floats[0..f.n], 0..) |x, i| {
                if (f.elem == 8) put(f64, at + i * 8, x) else put(f32, at + i * 4, @floatCast(x));
            }
        },
        .name, .string, .weak => return fail(error.WrongType, "Names, strings and weak objects can't be set yet. Use address and memory", .{}),
    }
}

fn put(comptime T: type, at: usize, value: T) void {
    @as(*align(1) T, @ptrFromInt(at)).* = value;
}

fn number(x: anytype) Value {
    var v = none;
    v.kind = .number;
    v.number = x;
    return v;
}

fn integer(x: anytype) Value {
    var v = none;
    v.kind = .integer;
    v.integer = x;
    return v;
}

fn asNumber(v: Value) Error!f64 {
    return switch (v.kind) {
        .number => v.number,
        .integer => @floatFromInt(v.integer),
        .flag => if (v.flag) 1 else 0,
        else => wrongValue(v, "a number"),
    };
}

fn asInteger(v: Value) Error!i64 {
    return switch (v.kind) {
        .integer => v.integer,
        .number => std.math.lossyCast(i64, v.number),
        .flag => @intFromBool(v.flag),
        else => wrongValue(v, "a whole number"),
    };
}

fn wrongValue(v: Value, want: []const u8) Error {
    return fail(error.WrongType, "It needs {s}, not {t}", .{ want, v.kind });
}

/// An FString: its UTF-16 and length, up to 1024 characters.
fn readString(ue: *const Unreal, a: std.mem.Allocator, at: usize) []const u8 {
    const arr = ue.mem.read(Unreal.TArray, at) orelse return "";
    const num = arr.num;
    if (arr.data == 0 or num <= 1) return "";
    const n: usize = @min(@as(usize, @intCast(num - 1)), 1024);
    var units: [1024]u16 = undefined;
    if (!ue.mem.bytes(arr.data, std.mem.sliceAsBytes(units[0..n]))) return "";
    return std.unicode.utf16LeToUtf8Alloc(a, units[0..n]) catch "";
}
