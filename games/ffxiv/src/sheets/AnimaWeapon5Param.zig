//! `AnimaWeapon5Param`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `BaseParam`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AnimaWeapon5Param = @This();

pub const sheet_name = "AnimaWeapon5Param";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5eb59ccb;
pub const Sheet = excel.Typed(AnimaWeapon5Param);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `BaseParam`.
pub fn baseParam(self: @This()) excel.Link(sheets.BaseParam) {
    return .of(self.row.at(u8, 4));
}
