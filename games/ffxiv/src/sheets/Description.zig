//! `Description`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `TextLong`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Description = @This();

pub const sheet_name = "Description";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x17dc52a3;
pub const Sheet = excel.Typed(Description);

row: excel.Row,

pub fn textLong(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn textShort(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn textCommentary(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

/// Links to `Quest`.
pub fn quest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 12));
}

/// Links to `DescriptionSection`.
pub fn section(self: @This()) excel.Link(sheets.DescriptionSection) {
    return .of(self.row.at(u32, 16));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 20);
}

pub fn unknown1(self: @This()) bool {
    return self.row.bitAt(21, 0);
}
