//! `MountSpeed`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Quest`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MountSpeed = @This();

pub const sheet_name = "MountSpeed";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x91ab8236;
pub const Sheet = excel.Typed(MountSpeed);

row: excel.Row,

/// Links to `Quest`.
pub fn quest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 0));
}

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 8);
}
