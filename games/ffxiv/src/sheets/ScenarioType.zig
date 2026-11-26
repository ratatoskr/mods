//! `ScenarioType`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Type`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ScenarioType = @This();

pub const sheet_name = "ScenarioType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x9e3430e1;
pub const Sheet = excel.Typed(ScenarioType);

row: excel.Row,

pub fn @"type"(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown0(self: @This()) i8 {
    return self.row.at(i8, 4);
}
