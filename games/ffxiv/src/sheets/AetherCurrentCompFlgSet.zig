//! `AetherCurrentCompFlgSet`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AetherCurrentCompFlgSet = @This();

pub const sheet_name = "AetherCurrentCompFlgSet";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x39815af8;
pub const Sheet = excel.Typed(AetherCurrentCompFlgSet);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Territory", "AetherCurrents[0]", "AetherCurrents[1]", "AetherCurrents[2]", "AetherCurrents[3]", "AetherCurrents[4]", "AetherCurrents[5]", "AetherCurrents[6]", "AetherCurrents[7]", "AetherCurrents[8]", "AetherCurrents[9]", "AetherCurrents[10]", "AetherCurrents[11]", "AetherCurrents[12]", "AetherCurrents[13]", "AetherCurrents[14]" };

/// Links to `TerritoryType`.
pub fn territory(self: @This()) excel.Link(sheets.TerritoryType) {
    return .of(self.row.at(i32, 0));
}

pub const aether_currents_len = 15;
/// Links to `AetherCurrent`.
pub fn aetherCurrents(self: @This(), n0: usize) excel.Link(sheets.AetherCurrent) {
    return .of(self.row.at(i32, offsets_1[n0]));
}

const offsets_1 = [15]u16{ 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60 };
