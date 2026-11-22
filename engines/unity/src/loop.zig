//! Unity's player loop, the list of what it runs each frame on its main thread. Each step's native
//! function is in it, so hooking one runs on the main thread at that point of every frame, whatever
//! the render pipeline. Unity's engine call `PlayerLoop.GetCurrentPlayerLoopInternal` gives it as
//! a flat array of `PlayerLoopSystemInternal`s, each step after the one it's in. That's there even
//! in games whose build strips the C# `PlayerLoop` class, like Berseria.

const std = @import("std");
const sdk = @import("wraith_sdk");

const W = sdk.api.wraith;
const local = sdk.mem.Memory.local;
const word = @sizeOf(usize);
/// An object's header, before a struct's fields
const header = 2 * word;
/// An array's length, after its header and bounds
const array_length = 3 * word;
const array_items = 4 * word;
/// Unity's loop has a couple of hundred
const max_steps = 1024;

/// Since Unity 2019.3, then before it.
const namespaces = [_][]const u8{ "UnityEngine.LowLevel", "UnityEngine.Experimental.LowLevel" };
const step_namespaces = [_][]const u8{ "UnityEngine.PlayerLoop", "UnityEngine.Experimental.PlayerLoop" };

/// Where a `PlayerLoopSystemInternal`'s fields are, from the start of its fields.
pub const Layout = struct {
    size: usize,
    type: usize,
    update_function: usize,
};

/// Where Unity keeps the native function for each of `steps`, like `PostLateUpdate/FinishFrameRendering`,
/// or null for ones this Unity doesn't have. Blocks while the game's runtime looks.
pub fn find(managed: W.Managed, comptime steps: []const []const u8) ![steps.len]?usize {
    for (namespaces, step_namespaces) |ns, step_ns| {
        var buf: [128]u8 = undefined;
        const get = managed.icall(try std.fmt.bufPrint(&buf, "{s}.PlayerLoop", .{ns}), "GetCurrentPlayerLoopInternal") catch continue;
        var sbuf: [128]u8 = undefined;
        const layout = try layoutOf(managed, try std.fmt.bufPrint(&sbuf, "{s}.PlayerLoopSystemInternal", .{ns}));
        var wants: [steps.len]usize = undefined;
        for (steps, &wants) |step, *want| {
            var tbuf: [128]u8 = undefined;
            want.* = managed.typeObject(try std.fmt.bufPrint(&tbuf, "{s}.{s}", .{ step_ns, step })) catch 0;
        }
        // It makes a C# array, so it runs where the runtime knows the thread. Nothing holds on to
        // it, so it's read straight away
        const array = try managed.callNative(get);
        if (array == 0) return error.NoPlayerLoop;
        var out: [steps.len]?usize = undefined;
        for (wants, &out) |want, *o| o.* = if (want == 0) null else search(array, layout, want);
        return out;
    }
    return error.NoPlayerLoop;
}

fn layoutOf(managed: W.Managed, system: []const u8) !Layout {
    const class = try managed.find(system);
    return .{
        .size = class.size - header,
        .type = try managed.fieldOffset(system, "type") - header,
        .update_function = try managed.fieldOffset(system, "updateFunction") - header,
    };
}

/// The `updateFunction` of the step in `array` whose type is `want`.
pub fn search(array: usize, layout: Layout, want: usize) ?usize {
    const n = local.load(usize, array + array_length) catch return null;
    for (0..@min(n, max_steps)) |i| {
        const at = array + array_items + i * layout.size;
        const t = local.load(usize, at + layout.type) catch return null;
        if (t != want) continue;
        const f = local.load(usize, at + layout.update_function) catch return null;
        return if (f == 0) null else f;
    }
    return null;
}

/// Unity's `updateFunction` points at where it keeps the function, which it calls through. Some
/// builds might point at the code itself, so it says which.
pub const Target = union(enum) { slot: usize, code: usize };

pub fn targetOf(update_function: usize) ?Target {
    if (executable(update_function)) return .{ .code = update_function };
    const f = local.load(usize, update_function) catch return null;
    return if (executable(f)) .{ .slot = update_function } else null;
}

fn executable(at: usize) bool {
    const r = local.regionFrom(at) orelse return false;
    return r.executable;
}

test "finds a step's function in the flat loop" {
    const testing = std.testing;
    // Laid out like Unity's: type, updateDelegate, updateFunction, loopConditionFunction, count
    const layout: Layout = .{ .size = 5 * word, .type = 0, .update_function = 2 * word };
    const Array = extern struct { head: [3]usize = .{ 0, 0, 0 }, len: usize, items: [3][5]usize };
    var array: Array = .{ .len = 3, .items = .{ .{ 0x10, 0, 0x1111, 0, 2 }, .{ 0x20, 0, 0x2222, 0, 0 }, .{ 0x30, 0, 0, 0, 0 } } };
    try testing.expectEqual(0x2222, search(@intFromPtr(&array), layout, 0x20));
    try testing.expectEqual(0x1111, search(@intFromPtr(&array), layout, 0x10));
    // A step with no function of its own, and one that isn't there
    try testing.expectEqual(null, search(@intFromPtr(&array), layout, 0x30));
    try testing.expectEqual(null, search(@intFromPtr(&array), layout, 0x99));
}

test "a slot's told apart from code" {
    const testing = std.testing;
    const code = @intFromPtr(&search);
    var slot: usize = code;
    try testing.expectEqual(Target{ .code = code }, targetOf(code).?);
    try testing.expectEqual(Target{ .slot = @intFromPtr(&slot) }, targetOf(@intFromPtr(&slot)).?);
    var data: usize = 5;
    try testing.expectEqual(null, targetOf(@intFromPtr(&data)));
}
