//! `TripleTriadResident`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TripleTriadResident = @This();

pub const sheet_name = "TripleTriadResident";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd870e208;
pub const Sheet = excel.Typed(TripleTriadResident);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{"Order"};

pub fn order(self: @This()) u16 {
    return self.row.at(u16, 0);
}
