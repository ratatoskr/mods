//! `ActionTimelineReplace`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ActionTimelineReplace = @This();

pub const sheet_name = "ActionTimelineReplace";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x2020acf6;
pub const Sheet = excel.Typed(ActionTimelineReplace);

row: excel.Row,

/// Links to `ActionTimeline`.
pub fn old(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 0));
}

/// Links to `ActionTimeline`.
pub fn new(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 2));
}
