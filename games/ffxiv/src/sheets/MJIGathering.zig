//! `MJIGathering`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `GatheringObject`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJIGathering = @This();

pub const sheet_name = "MJIGathering";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdcfd9eba;
pub const Sheet = excel.Typed(MJIGathering);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{"GatheringObject"};

/// Links to `MJIGatheringObject`.
pub fn gatheringObject(self: @This()) excel.Link(sheets.MJIGatheringObject) {
    return .of(self.row.at(u8, 0));
}
