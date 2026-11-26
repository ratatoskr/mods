//! `AnimaWeaponFUITalkParam`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Prologue`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AnimaWeaponFUITalkParam = @This();

pub const sheet_name = "AnimaWeaponFUITalkParam";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x9db0e48f;
pub const Sheet = excel.Typed(AnimaWeaponFUITalkParam);

row: excel.Row,

pub fn prologue(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn epilogue(self: @This()) []const u8 {
    return self.row.stringAt(4);
}
