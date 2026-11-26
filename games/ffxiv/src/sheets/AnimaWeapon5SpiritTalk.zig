//! `AnimaWeapon5SpiritTalk`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Dialogue`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AnimaWeapon5SpiritTalk = @This();

pub const sheet_name = "AnimaWeapon5SpiritTalk";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xda365c51;
pub const Sheet = excel.Typed(AnimaWeapon5SpiritTalk);

row: excel.Row,

/// Links to `AnimaWeapon5SpiritTalkParam`.
pub fn dialogue(self: @This()) excel.Link(sheets.AnimaWeapon5SpiritTalkParam) {
    return .of(self.row.at(i32, 0));
}
