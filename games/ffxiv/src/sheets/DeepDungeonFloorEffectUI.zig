//! `DeepDungeonFloorEffectUI`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DeepDungeonFloorEffectUI = @This();

pub const sheet_name = "DeepDungeonFloorEffectUI";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x11a44a12;
pub const Sheet = excel.Typed(DeepDungeonFloorEffectUI);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 8);
}
