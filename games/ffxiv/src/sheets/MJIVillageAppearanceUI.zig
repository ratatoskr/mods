//! `MJIVillageAppearanceUI`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJIVillageAppearanceUI = @This();

pub const sheet_name = "MJIVillageAppearanceUI";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x248f1d6a;
pub const Sheet = excel.Typed(MJIVillageAppearanceUI);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Floor", "Unknown0", "Unknown1" };

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn floor(self: @This()) i32 {
    return self.row.at(i32, 0);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 6);
}
