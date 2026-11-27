//! `TripleTriadCardRarity`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Stars`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TripleTriadCardRarity = @This();

pub const sheet_name = "TripleTriadCardRarity";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdcfd9eba;
pub const Sheet = excel.Typed(TripleTriadCardRarity);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{"Stars"};

pub fn stars(self: @This()) u8 {
    return self.row.at(u8, 0);
}
