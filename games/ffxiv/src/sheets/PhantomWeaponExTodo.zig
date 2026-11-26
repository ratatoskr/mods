//! `PhantomWeaponExTodo`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PhantomWeaponExTodo = @This();

pub const sheet_name = "PhantomWeaponExTodo";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x98fff20a;
pub const Sheet = excel.Typed(PhantomWeaponExTodo);

row: excel.Row,

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 4);
}
