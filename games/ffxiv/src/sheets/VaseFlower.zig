//! `VaseFlower`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const VaseFlower = @This();

pub const sheet_name = "VaseFlower";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x8c05af34;
pub const Sheet = excel.Typed(VaseFlower);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Unknown1", "Unknown2", "Item" };

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 0));
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 6);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 7);
}
