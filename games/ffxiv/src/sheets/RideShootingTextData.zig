//! `RideShootingTextData`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `String`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const RideShootingTextData = @This();

pub const sheet_name = "RideShootingTextData";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdebb20e3;
pub const Sheet = excel.Typed(RideShootingTextData);

row: excel.Row,

pub fn string(self: @This()) []const u8 {
    return self.row.stringAt(0);
}
