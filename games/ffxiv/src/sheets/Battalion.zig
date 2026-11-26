//! `Battalion`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Battalion = @This();

pub const sheet_name = "Battalion";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xa485bf48;
pub const Sheet = excel.Typed(Battalion);

row: excel.Row,

pub const is_enemy_to_len = 15;
/// Index is the other battalion.
pub fn isEnemyTo(self: @This(), n0: usize) bool {
    return self.row.at(u8, offsets_1[n0]) != 0;
}

const offsets_1 = [15]u16{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 };
