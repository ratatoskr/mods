//! Every class and struct as text, with their properties' offsets and types and their functions.
//! For finding your way around a game, and later for writing its schemas.

const std = @import("std");

const Unreal = @import("Unreal.zig");

pub const Counts = struct { classes: usize = 0, structs: usize = 0 };

pub fn write(ue: *const Unreal, w: *std.Io.Writer) !Counts {
    var counts: Counts = .{};
    var buf: [512]u8 = undefined;
    var kind_buf: [256]u8 = undefined;
    for (0..ue.objects.count()) |i| {
        const obj = ue.objects.get(i) orelse continue;
        const kind = kindOf(ue, obj, &kind_buf) orelse continue;
        const path = ue.pathOf(obj, &buf) orelse continue;
        switch (kind) {
            .class => counts.classes += 1,
            .@"struct" => counts.structs += 1,
        }
        try w.print("{s} {s}", .{ @tagName(kind), path });
        if (ue.superOf(obj)) |s| if (ue.nameOf(s, &kind_buf)) |name| try w.print(" : {s}", .{name});
        try w.print(" // 0x{x} bytes\n", .{@as(u32, @bitCast(ue.structSize(obj) orelse 0))});
        try fields(ue, obj, w);
        try w.writeAll("\n");
    }
    return counts;
}

const Kind = enum { class, @"struct" };

/// Classes and structs, by what their class comes from. Not functions, which are listed in theirs.
fn kindOf(ue: *const Unreal, obj: usize, buf: []u8) ?Kind {
    const class = ue.classOf(obj) orelse return null;
    const name = ue.nameOf(class, buf) orelse return null;
    if (std.mem.eql(u8, name, "ScriptStruct") or std.mem.eql(u8, name, "UserDefinedStruct")) return .@"struct";
    if (std.mem.eql(u8, name, "Function") or std.mem.eql(u8, name, "DelegateFunction") or std.mem.eql(u8, name, "SparseDelegateFunction")) return null;
    // Class, and the Blueprint ones, come from Class
    var at: ?usize = class;
    var depth: usize = 0;
    while (at) |c| : (at = ue.superOf(c)) {
        depth += 1;
        if (depth > 32) return null;
        const n = ue.nameOf(c, buf) orelse return null;
        if (std.mem.eql(u8, n, "Class")) return .class;
    }
    return null;
}

fn fields(ue: *const Unreal, strct: usize, w: *std.Io.Writer) !void {
    var name_buf: [256]u8 = undefined;
    var kind_buf: [256]u8 = undefined;
    var type_buf: [256]u8 = undefined;
    var field = ue.firstField(strct);
    var n: usize = 0;
    while (field) |f| : (field = ue.nextField(f)) {
        n += 1;
        if (n > 4096) break;
        const kind = ue.fieldKind(f, &kind_buf) orelse "?";
        const name = ue.fieldName(f, &name_buf) orelse "?";
        // Before 4.25 functions are among these, they're listed below
        if (!std.mem.endsWith(u8, kind, "Property")) continue;
        const p = ue.property(f) orelse continue;
        try w.print("    0x{x:0>4} {s} {s}", .{ @as(u32, @bitCast(p.offset)), kind, name });
        if (p.count > 1) try w.print("[{d}]", .{p.count});
        if (p.type) |t| if (ue.nameOf(t, &type_buf)) |tn| try w.print(": {s}", .{tn});
        try w.print(" // {d}\n", .{p.size});
    }
    var func = ue.firstFunction(strct);
    n = 0;
    while (func) |f| : (func = ue.mem.ptr(f + ue.layout.field_next)) {
        n += 1;
        if (n > 4096) break;
        const kind = ue.classNameOf(f, &kind_buf) orelse continue;
        if (!std.mem.endsWith(u8, kind, "Function")) continue;
        try w.print("    fn {s}\n", .{ue.nameOf(f, &name_buf) orelse "?"});
    }
}
