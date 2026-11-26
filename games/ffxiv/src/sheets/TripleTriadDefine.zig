//! `TripleTriadDefine`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TripleTriadDefine = @This();

pub const sheet_name = "TripleTriadDefine";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xda365c51;
pub const Sheet = excel.Typed(TripleTriadDefine);

row: excel.Row,

pub fn value(self: @This()) i32 {
    return self.row.at(i32, 0);
}
