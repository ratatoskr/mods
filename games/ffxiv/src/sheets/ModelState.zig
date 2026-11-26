//! `ModelState`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Start`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ModelState = @This();

pub const sheet_name = "ModelState";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd73eab80;
pub const Sheet = excel.Typed(ModelState);

row: excel.Row,

/// Links to `ActionTimeline`.
pub fn start(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 0));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 2);
}
