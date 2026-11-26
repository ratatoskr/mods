//! `GoldSaucerContent`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GoldSaucerContent = @This();

pub const sheet_name = "GoldSaucerContent";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xab081b6b;
pub const Sheet = excel.Typed(GoldSaucerContent);

row: excel.Row,

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 0);
}

/// Links to `ContentFinderCondition`.
pub fn contentFinderCondition(self: @This()) excel.Link(sheets.ContentFinderCondition) {
    return .of(self.row.at(u16, 2));
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn timeLimit(self: @This()) u8 {
    return self.row.at(u8, 5);
}
