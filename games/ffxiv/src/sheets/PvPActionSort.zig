//! `PvPActionSort`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Action`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PvPActionSort = @This();

pub const sheet_name = "PvPActionSort";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xc3af756b;
pub const Sheet = excel.Typed(PvPActionSort);

row: excel.Row,

pub fn unknown0(self: @This()) i32 {
    return self.row.at(i32, 0);
}

/// Links by `ActionType`: 1 to `Action`, 2 to `ActionComboRoute`.
pub fn action(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn actionType(self: @This()) u8 {
    return self.row.at(u8, 6);
}

pub fn unknown1(self: @This()) bool {
    return self.row.bitAt(7, 0);
}

pub fn unknown2(self: @This()) bool {
    return self.row.bitAt(7, 1);
}
