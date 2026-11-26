//! `exd/root.exl`, every sheet's name and the id the game knows it by. Lines of `Name,id` after an
//! `EXLT,version` one, with -1 for sheets with no id.

const List = @This();

const std = @import("std");

pub const Entry = struct {
    name: []const u8,
    id: ?u32,
};

/// The file, which the names point into.
text: []u8,
/// By name, ignoring case.
by_name: []Entry,
/// The ones with ids, by id.
by_id: []Entry,

pub const ParseError = error{ NotExcelList, BadLine, OutOfMemory };

/// Takes `text`, which `deinit` frees. If it fails, `text` is still the caller's.
pub fn parse(gpa: std.mem.Allocator, text: []u8) ParseError!List {
    var lines = std.mem.splitSequence(u8, text, "\r\n");
    const first = lines.next() orelse return error.NotExcelList;
    if (!std.mem.startsWith(u8, first, "EXLT,")) return error.NotExcelList;

    var entries: std.ArrayList(Entry) = .empty;
    defer entries.deinit(gpa);
    var with_id: usize = 0;
    while (lines.next()) |line| {
        if (line.len == 0) continue;
        const comma = std.mem.lastIndexOfScalar(u8, line, ',') orelse return error.BadLine;
        if (comma == 0) return error.BadLine;
        const id = std.fmt.parseInt(i32, line[comma + 1 ..], 10) catch return error.BadLine;
        if (id < -1) return error.BadLine;
        try entries.append(gpa, .{ .name = line[0..comma], .id = if (id < 0) null else @intCast(id) });
        with_id += @intFromBool(id >= 0);
    }

    const by_name = try entries.toOwnedSlice(gpa);
    errdefer gpa.free(by_name);
    const by_id = try gpa.alloc(Entry, with_id);
    var n: usize = 0;
    for (by_name) |e| if (e.id != null) {
        by_id[n] = e;
        n += 1;
    };
    std.mem.sort(Entry, by_name, {}, nameLess);
    std.mem.sort(Entry, by_id, {}, idLess);
    return .{ .text = text, .by_name = by_name, .by_id = by_id };
}

pub fn deinit(self: *List, gpa: std.mem.Allocator) void {
    gpa.free(self.by_id);
    gpa.free(self.by_name);
    gpa.free(self.text);
    self.* = undefined;
}

/// With its name as the list has it, which can be cased differently.
pub fn find(self: *const List, name: []const u8) ?Entry {
    const i = std.sort.binarySearch(Entry, self.by_name, name, struct {
        fn order(key: []const u8, e: Entry) std.math.Order {
            return std.ascii.orderIgnoreCase(key, e.name);
        }
    }.order) orelse return null;
    return self.by_name[i];
}

pub fn nameOf(self: *const List, id: u32) ?[]const u8 {
    const i = std.sort.binarySearch(Entry, self.by_id, id, struct {
        fn order(key: u32, e: Entry) std.math.Order {
            return std.math.order(key, e.id.?);
        }
    }.order) orelse return null;
    return self.by_id[i].name;
}

fn nameLess(_: void, a: Entry, b: Entry) bool {
    return std.ascii.orderIgnoreCase(a.name, b.name) == .lt;
}

fn idLess(_: void, a: Entry, b: Entry) bool {
    return a.id.? < b.id.?;
}

test "parses a list" {
    const t = std.testing;
    var list = try parse(t.allocator, try t.allocator.dupe(u8, "EXLT,2\r\nItem,10\r\nguild_order/GuildOrderGuide,-1\r\nAction,4\r\n"));
    defer list.deinit(t.allocator);
    try t.expectEqual(10, list.find("ITEM").?.id);
    try t.expectEqualStrings("Item", list.find("item").?.name);
    try t.expectEqual(null, list.find("guild_order/GuildOrderGuide").?.id);
    try t.expectEqual(null, list.find("Nope"));
    try t.expectEqualStrings("Action", list.nameOf(4).?);
    try t.expectEqual(null, list.nameOf(5));
}

test "lists it can't take" {
    const t = std.testing;
    for ([_][]const u8{ "Blah\r\n", "EXLT,2\r\nItem\r\n", "EXLT,2\r\nItem,\r\n", "EXLT,2\r\n,3\r\n", "EXLT,2\r\nItem,x\r\n" }) |text| {
        const owned = try t.allocator.dupe(u8, text);
        defer t.allocator.free(owned);
        try t.expect(std.meta.isError(parse(t.allocator, owned)));
    }
}
