//! `ScreenImage`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ScreenImage = @This();

pub const sheet_name = "ScreenImage";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x215f3acf;
pub const Sheet = excel.Typed(ScreenImage);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Image", "Jingle", "Type", "Lang", "Unknown0" };

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn image(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown0(self: @This()) i32 {
    return self.row.at(i32, 4);
}

/// Links to `Jingle`.
pub fn jingle(self: @This()) excel.Link(sheets.Jingle) {
    return .of(self.row.at(i16, 8));
}

pub fn @"type"(self: @This()) i8 {
    return self.row.at(i8, 10);
}

pub fn lang(self: @This()) bool {
    return self.row.bitAt(11, 0);
}
