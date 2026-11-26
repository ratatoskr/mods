//! `IKDContentBonus`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Objective`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const IKDContentBonus = @This();

pub const sheet_name = "IKDContentBonus";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xb7d9b7a3;
pub const Sheet = excel.Typed(IKDContentBonus);

row: excel.Row,

pub fn objective(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn requirement(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn image(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn bonusMultiplier(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn order(self: @This()) u8 {
    return self.row.at(u8, 14);
}
