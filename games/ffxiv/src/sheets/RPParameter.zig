//! `RPParameter`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `BNpcName`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const RPParameter = @This();

pub const sheet_name = "RPParameter";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x251a33cc;
pub const Sheet = excel.Typed(RPParameter);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "BNpcName", "ClassJob", "Sex" };

/// Links to `BNpcName`.
pub fn bNpcName(self: @This()) excel.Link(sheets.BNpcName) {
    return .of(self.row.at(u16, 0));
}

/// Links to `ClassJob`.
pub fn classJob(self: @This()) excel.Link(sheets.ClassJob) {
    return .of(self.row.at(u8, 2));
}

pub fn sex(self: @This()) u8 {
    return self.row.at(u8, 3);
}
