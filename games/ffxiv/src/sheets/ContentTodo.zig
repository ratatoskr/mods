//! `ContentTodo`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Objective`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ContentTodo = @This();

pub const sheet_name = "ContentTodo";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x5b3b0b21;
pub const Sheet = excel.Typed(ContentTodo);

row: excel.Row,

/// Links to `InstanceContentTextData`.
pub fn objective(self: @This()) excel.Link(sheets.InstanceContentTextData) {
    return .of(self.row.at(u32, 0));
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 5);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 6);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(7, 0);
}
