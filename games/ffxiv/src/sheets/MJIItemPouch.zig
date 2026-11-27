//! `MJIItemPouch`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJIItemPouch = @This();

pub const sheet_name = "MJIItemPouch";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x471e775e;
pub const Sheet = excel.Typed(MJIItemPouch);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Item", "Category", "Crop", "Unknown0" };

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 0));
}

/// Links to `MJIItemCategory`.
pub fn category(self: @This()) excel.Link(sheets.MJIItemCategory) {
    return .of(self.row.at(i32, 4));
}

/// Links to `MJICropSeed`.
pub fn crop(self: @This()) excel.Link(sheets.MJICropSeed) {
    return .of(self.row.at(u8, 8));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 9);
}
