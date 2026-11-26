//! `AnimaWeaponIcon`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `ZodiacLux`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AnimaWeaponIcon = @This();

pub const sheet_name = "AnimaWeaponIcon";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x63c20db3;
pub const Sheet = excel.Typed(AnimaWeaponIcon);

row: excel.Row,

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn hyperconductive(self: @This()) i32 {
    return self.row.at(i32, 0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn reborn(self: @This()) i32 {
    return self.row.at(i32, 4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn sharpened(self: @This()) i32 {
    return self.row.at(i32, 8);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn zodiac(self: @This()) i32 {
    return self.row.at(i32, 12);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn zodiacLux(self: @This()) i32 {
    return self.row.at(i32, 16);
}
