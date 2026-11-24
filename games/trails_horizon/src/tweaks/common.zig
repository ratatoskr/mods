//! What the tweaks share: their headings, item ids and a few helpers.

const std = @import("std");
const sdk = @import("wraith_sdk");
const schema = @import("schema");

const W = sdk.api.wraith;

/// Headings in the Tweaks window
pub const sections = struct {
    pub const money = "Money";
    pub const items = "Items";
    pub const exp = "Experience";
    pub const combat = "Combat";
    pub const party = "Party";
    pub const field = "Field";
    pub const fishing = "Fishing";
    pub const garten = "Grim Garten";
    pub const misc = "Misc";
};

/// Item ids past the real items, for Sepith, all of it at once, and G-Tokens.
const first_sepith = 0x136;
const last_special = 0x13F;

pub fn isItem(id: u32) bool {
    return id < first_sepith or id > last_special;
}

/// A hook a few tweaks share, on while any of them is.
pub fn sync(hook: anytype, any: bool) !void {
    if (any) try hook.enable() else try hook.disable();
}

pub fn times(value: i32, by: u32) i32 {
    const wide = @as(i64, value) * by;
    return @intCast(std.math.clamp(wide, std.math.minInt(i32), std.math.maxInt(i32)));
}

/// What t_name calls a character, like "Van". Null if it's not there.
pub fn nameOf(chrid: u32) ?[]const u8 {
    const manager = schema.DataTableManager.instance() catch return null;
    const table = sdk.salamander.follow(manager, "names.table") orelse return null;
    const all: [*]const schema.TableSection = @ptrCast(table.sections orelse return null);
    const s = &all[table.section];
    for (0..s.count) |i| {
        const row: *const schema.NameRow = @ptrFromInt(table.data + s.offset + i * s.stride);
        if (row.chrid != chrid) continue;
        const text = std.mem.span(row.name orelse return null);
        return if (text.len > 0) text else null;
    }
    return null;
}

/// Every item there is, once the tables are loaded.
pub fn itemTable() ?[]schema.Item {
    const manager = schema.DataTableManager.instance() catch return null;
    const data = sdk.salamander.follow(manager, "items.table.data") orelse return null;
    return data.itemsSlice();
}

/// An item's name, like "Tear Balm". Null if it's not there or has none.
pub fn itemName(id: u32) ?[]const u8 {
    for (itemTable() orelse return null) |item| {
        if (item.id != id) continue;
        const text = std.mem.span(item.name orelse return null);
        return if (text.len > 0) text else null;
    }
    return null;
}

/// Bytes put over the game's code while a tweak's on, at a place found by its signature.
pub const Spot = struct {
    at: sdk.Address,
    bytes: []const u8,
    /// What has to be there first
    expect: []const u8,
};

/// A tweak that's on while its spots are patched.
pub const Patches = struct {
    list: [4]W.Patch = undefined,
    count: usize = 0,
    allocator: std.mem.Allocator,

    pub fn enable(self: *Patches) !void {
        for (self.list[0..self.count]) |p| try p.enable();
    }

    pub fn disable(self: *Patches) !void {
        for (self.list[0..self.count]) |p| p.disable() catch {};
    }

    fn free(self: *Patches) void {
        self.allocator.destroy(self);
    }
};

/// A tweak that patches every spot while it's on. Fails if one isn't what it should be.
pub fn patchTweak(ctx: *sdk.Context, definition: sdk.tweaks.Definition, spots: []const Spot) !void {
    const self = try ctx.allocator.create(Patches);
    self.* = .{ .allocator = ctx.allocator };
    ctx.configs.add(self, Patches.free) catch |err| {
        ctx.allocator.destroy(self);
        return err;
    };
    const code = ctx.wraith.code();
    for (spots) |s| {
        const at = try s.at.unwrap();
        self.list[self.count] = try code.patchBytes(at, s.bytes, .{ .size = 0, .expect = s.expect, .disabled = true, .names = &.{} });
        self.count += 1;
    }
    try sdk.tweaks.hook(ctx, definition, self);
}
