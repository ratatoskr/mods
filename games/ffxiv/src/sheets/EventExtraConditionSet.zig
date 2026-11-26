//! `EventExtraConditionSet`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EventExtraConditionSet = @This();

pub const sheet_name = "EventExtraConditionSet";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5bfa8a4e;
pub const Sheet = excel.Typed(EventExtraConditionSet);

row: excel.Row,

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 4);
}
