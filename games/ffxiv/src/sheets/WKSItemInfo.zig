//! `WKSItemInfo`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSItemInfo = @This();

pub const sheet_name = "WKSItemInfo";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x4c9bc8ff;
pub const Sheet = excel.Typed(WKSItemInfo);

row: excel.Row,

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 0));
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 6);
}

/// Links to `WKSItemSubCategory`.
pub fn wksItemSubCategory(self: @This()) excel.Link(sheets.WKSItemSubCategory) {
    return .of(self.row.at(u8, 7));
}

pub fn unknown3(self: @This()) bool {
    return self.row.bitAt(8, 0);
}
