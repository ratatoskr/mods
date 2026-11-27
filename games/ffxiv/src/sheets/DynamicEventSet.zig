//! `DynamicEventSet`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DynamicEventSet = @This();

pub const sheet_name = "DynamicEventSet";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xd870e208;
pub const Sheet = excel.Typed(DynamicEventSet);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{"DynamicEvent"};

/// Links to `DynamicEvent`.
pub fn dynamicEvent(self: @This()) excel.Link(sheets.DynamicEvent) {
    return .of(self.row.at(u16, 0));
}
