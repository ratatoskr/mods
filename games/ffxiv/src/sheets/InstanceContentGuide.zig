//! `InstanceContentGuide`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const InstanceContentGuide = @This();

pub const sheet_name = "InstanceContentGuide";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5d58cc84;
pub const Sheet = excel.Typed(InstanceContentGuide);

row: excel.Row,

/// Links to `InstanceContent`.
pub fn instance(self: @This()) excel.Link(sheets.InstanceContent) {
    return .of(self.row.at(u32, 0));
}

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 4);
}
