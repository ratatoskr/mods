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

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "IsEnemyTo[0]", "IsEnemyTo[1]", "IsEnemyTo[2]", "IsEnemyTo[3]", "IsEnemyTo[4]", "IsEnemyTo[5]", "IsEnemyTo[6]", "IsEnemyTo[7]", "IsEnemyTo[8]", "IsEnemyTo[9]", "IsEnemyTo[10]", "IsEnemyTo[11]", "IsEnemyTo[12]", "IsEnemyTo[13]", "IsEnemyTo[14]" };

pub const is_enemy_to_len = 15;
/// Index is the other battalion.
pub fn isEnemyTo(self: @This(), n0: usize) bool {
    return self.row.at(u8, offsets_1[n0]) != 0;
}

const offsets_1 = [15]u16{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 };
