//! `HouseRetainerPose`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `ActionTimeline`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HouseRetainerPose = @This();

pub const sheet_name = "HouseRetainerPose";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd870e208;
pub const Sheet = excel.Typed(HouseRetainerPose);

row: excel.Row,

/// Links to `ActionTimeline`.
pub fn actionTimeline(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 0));
}
