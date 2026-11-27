//! `WKSMissionLotteryCond`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSMissionLotteryCond = @This();

pub const sheet_name = "WKSMissionLotteryCond";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdcfd9eba;
pub const Sheet = excel.Typed(WKSMissionLotteryCond);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{"RequiredFunction"};

/// Links to `WKSFunction`.
pub fn requiredFunction(self: @This()) excel.Link(sheets.WKSFunction) {
    return .of(self.row.at(u8, 0));
}
