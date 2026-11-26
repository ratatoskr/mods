//! `GcArmyCaptureTactics`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GcArmyCaptureTactics = @This();

pub const sheet_name = "GcArmyCaptureTactics";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x62bcfbad;
pub const Sheet = excel.Typed(GcArmyCaptureTactics);

row: excel.Row,

/// Links to `Addon`.
pub fn tactic(self: @This()) excel.Link(sheets.Addon) {
    return .of(self.row.at(u32, 0));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// Links to `Status`.
pub fn name(self: @This()) excel.Link(sheets.Status) {
    return .of(self.row.at(i32, 8));
}

pub fn hp(self: @This()) u8 {
    return self.row.at(u8, 12);
}

pub fn damageDealt(self: @This()) u8 {
    return self.row.at(u8, 13);
}

pub fn damageReceived(self: @This()) u8 {
    return self.row.at(u8, 14);
}
