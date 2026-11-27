//! `GatheringItemPoint`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `GatheringPoint`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GatheringItemPoint = @This();

pub const sheet_name = "GatheringItemPoint";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xdbf43666;
pub const Sheet = excel.Typed(GatheringItemPoint);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{"GatheringPoint"};

/// Links to `GatheringPoint`.
pub fn gatheringPoint(self: @This()) excel.Link(sheets.GatheringPoint) {
    return .of(self.row.at(u32, 0));
}
