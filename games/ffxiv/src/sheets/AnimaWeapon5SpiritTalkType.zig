//! `AnimaWeapon5SpiritTalkType`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AnimaWeapon5SpiritTalkType = @This();

pub const sheet_name = "AnimaWeapon5SpiritTalkType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdcfd9eba;
pub const Sheet = excel.Typed(AnimaWeapon5SpiritTalkType);

row: excel.Row,

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 0);
}
