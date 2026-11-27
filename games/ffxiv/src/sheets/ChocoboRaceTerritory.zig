//! `ChocoboRaceTerritory`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ChocoboRaceTerritory = @This();

pub const sheet_name = "ChocoboRaceTerritory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x39e8d543;
pub const Sheet = excel.Typed(ChocoboRaceTerritory);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "Icon" };

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 0);
}

/// Links to `GoldSaucerTextData`.
pub fn name(self: @This()) excel.Link(sheets.GoldSaucerTextData) {
    return .of(self.row.at(u16, 4));
}
