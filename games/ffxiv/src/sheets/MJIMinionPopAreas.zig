//! `MJIMinionPopAreas`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJIMinionPopAreas = @This();

pub const sheet_name = "MJIMinionPopAreas";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x3591bdd9;
pub const Sheet = excel.Typed(MJIMinionPopAreas);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "RequiredFunction", "X", "Y", "Text", "Unknown4" };

/// Links to `MJIText`.
pub fn text(self: @This()) excel.Link(sheets.MJIText) {
    return .of(self.row.at(i32, 0));
}

pub fn x(self: @This()) i16 {
    return self.row.at(i16, 4);
}

pub fn y(self: @This()) i16 {
    return self.row.at(i16, 6);
}

/// Links to `MJIFunction`.
pub fn requiredFunction(self: @This()) excel.Link(sheets.MJIFunction) {
    return .of(self.row.at(u8, 8));
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(9, 0);
}
