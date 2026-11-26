//! `DeepDungeonRoom`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DeepDungeonRoom = @This();

pub const sheet_name = "DeepDungeonRoom";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x6be0e840;
pub const Sheet = excel.Typed(DeepDungeonRoom);

row: excel.Row,

pub const level_len = 5;
/// Links to `Level`.
pub fn level(self: @This(), n0: usize) excel.Link(sheets.Level) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

const offsets_1 = [5]u16{ 0, 4, 8, 12, 16 };
