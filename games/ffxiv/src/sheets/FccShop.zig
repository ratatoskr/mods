//! `FccShop`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const FccShop = @This();

pub const sheet_name = "FccShop";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xccd13846;
pub const Sheet = excel.Typed(FccShop);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub const item_data_len = 10;
pub fn itemData(self: @This(), n0: usize) ItemDataEntry {
    std.debug.assert(n0 < 10);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const ItemDataEntry = struct {
    row: excel.Row,
    at: [1]u16,

    /// Links to `Item`.
    pub fn item(self: @This()) excel.Link(sheets.Item) {
        return .of(self.row.at(u32, offsets_1[self.at[0]]));
    }

    pub fn cost(self: @This()) u32 {
        return self.row.at(u32, offsets_2[self.at[0]]);
    }

    /// Links to `FCRank`.
    pub fn fcRankRequired(self: @This()) excel.Link(sheets.FCRank) {
        return .of(self.row.at(u8, offsets_3[self.at[0]]));
    }
};

const offsets_1 = [10]u16{ 4, 16, 28, 40, 52, 64, 76, 88, 100, 112 };
const offsets_2 = [10]u16{ 8, 20, 32, 44, 56, 68, 80, 92, 104, 116 };
const offsets_3 = [10]u16{ 12, 24, 36, 48, 60, 72, 84, 96, 108, 120 };
