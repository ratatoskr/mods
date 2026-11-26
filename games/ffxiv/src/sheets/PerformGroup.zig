//! `PerformGroup`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PerformGroup = @This();

pub const sheet_name = "PerformGroup";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5be005ad;
pub const Sheet = excel.Typed(PerformGroup);

row: excel.Row,

pub const perform_len = 5;
/// Links to `Perform`.
pub fn perform(self: @This(), n0: usize) excel.Link(sheets.Perform) {
    return .of(self.row.at(u8, offsets_1[n0]));
}

const offsets_1 = [5]u16{ 0, 1, 2, 3, 4 };
