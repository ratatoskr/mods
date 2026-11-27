//! `GCSupplyDuty`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GCSupplyDuty = @This();

pub const sheet_name = "GCSupplyDuty";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xb3265a92;
pub const Sheet = excel.Typed(GCSupplyDuty);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "SupplyData[0].Item[0]", "SupplyData[0].ItemCount[0]", "SupplyData[0].Item[1]", "SupplyData[0].ItemCount[1]", "SupplyData[0].Item[2]", "SupplyData[0].ItemCount[2]", "SupplyData[1].Item[0]", "SupplyData[1].ItemCount[0]", "SupplyData[1].Item[1]", "SupplyData[1].ItemCount[1]", "SupplyData[1].Item[2]", "SupplyData[1].ItemCount[2]", "SupplyData[2].Item[0]", "SupplyData[2].ItemCount[0]", "SupplyData[2].Item[1]", "SupplyData[2].ItemCount[1]", "SupplyData[2].Item[2]", "SupplyData[2].ItemCount[2]", "SupplyData[3].Item[0]", "SupplyData[3].ItemCount[0]", "SupplyData[3].Item[1]", "SupplyData[3].ItemCount[1]", "SupplyData[3].Item[2]", "SupplyData[3].ItemCount[2]", "SupplyData[4].Item[0]", "SupplyData[4].ItemCount[0]", "SupplyData[4].Item[1]", "SupplyData[4].ItemCount[1]", "SupplyData[4].Item[2]", "SupplyData[4].ItemCount[2]", "SupplyData[5].Item[0]", "SupplyData[5].ItemCount[0]", "SupplyData[5].Item[1]", "SupplyData[5].ItemCount[1]", "SupplyData[5].Item[2]", "SupplyData[5].ItemCount[2]", "SupplyData[6].Item[0]", "SupplyData[6].ItemCount[0]", "SupplyData[6].Item[1]", "SupplyData[6].ItemCount[1]", "SupplyData[6].Item[2]", "SupplyData[6].ItemCount[2]", "SupplyData[7].Item[0]", "SupplyData[7].ItemCount[0]", "SupplyData[7].Item[1]", "SupplyData[7].ItemCount[1]", "SupplyData[7].Item[2]", "SupplyData[7].ItemCount[2]", "SupplyData[8].Item[0]", "SupplyData[8].ItemCount[0]", "SupplyData[8].Item[1]", "SupplyData[8].ItemCount[1]", "SupplyData[8].Item[2]", "SupplyData[8].ItemCount[2]", "SupplyData[9].Item[0]", "SupplyData[9].ItemCount[0]", "SupplyData[9].Item[1]", "SupplyData[9].ItemCount[1]", "SupplyData[9].Item[2]", "SupplyData[9].ItemCount[2]", "SupplyData[10].Item[0]", "SupplyData[10].ItemCount[0]", "SupplyData[10].Item[1]", "SupplyData[10].ItemCount[1]", "SupplyData[10].Item[2]", "SupplyData[10].ItemCount[2]" };

pub const supply_data_len = 11;
pub fn supplyData(self: @This(), n0: usize) SupplyDataEntry {
    std.debug.assert(n0 < 11);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const SupplyDataEntry = struct {
    row: excel.Row,
    at: [1]u16,

    pub const item_len = 3;
    /// Links to `Item`.
    pub fn item(self: @This(), n1: usize) excel.Link(sheets.Item) {
        return .of(self.row.at(i32, offsets_1[self.at[0]][n1]));
    }

    pub const item_count_len = 3;
    pub fn itemCount(self: @This(), n1: usize) u8 {
        return self.row.at(u8, offsets_2[self.at[0]][n1]);
    }
};

const offsets_1 = [11][3]u16{ .{ 0, 4, 8 }, .{ 16, 20, 24 }, .{ 32, 36, 40 }, .{ 48, 52, 56 }, .{ 64, 68, 72 }, .{ 80, 84, 88 }, .{ 96, 100, 104 }, .{ 112, 116, 120 }, .{ 128, 132, 136 }, .{ 144, 148, 152 }, .{ 160, 164, 168 } };
const offsets_2 = [11][3]u16{ .{ 12, 13, 14 }, .{ 28, 29, 30 }, .{ 44, 45, 46 }, .{ 60, 61, 62 }, .{ 76, 77, 78 }, .{ 92, 93, 94 }, .{ 108, 109, 110 }, .{ 124, 125, 126 }, .{ 140, 141, 142 }, .{ 156, 157, 158 }, .{ 172, 173, 174 } };
