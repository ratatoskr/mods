//! `AnimaWeapon5SpiritTalkParam`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Prologue`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AnimaWeapon5SpiritTalkParam = @This();

pub const sheet_name = "AnimaWeapon5SpiritTalkParam";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x9db0e48f;
pub const Sheet = excel.Typed(AnimaWeapon5SpiritTalkParam);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Prologue", "Epilogue" };

pub fn prologue(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn epilogue(self: @This()) []const u8 {
    return self.row.stringAt(4);
}
