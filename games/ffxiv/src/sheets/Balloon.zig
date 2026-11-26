//! `Balloon`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Dialogue`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Balloon = @This();

pub const sheet_name = "Balloon";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x9d1b5f4b;
pub const Sheet = excel.Typed(Balloon);

row: excel.Row,

pub fn dialogue(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn slowly(self: @This()) bool {
    return self.row.bitAt(4, 0);
}
