//! `NotoriousMonsterTerritory`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const NotoriousMonsterTerritory = @This();

pub const sheet_name = "NotoriousMonsterTerritory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf057da9c;
pub const Sheet = excel.Typed(NotoriousMonsterTerritory);

row: excel.Row,

pub const notorious_monsters_len = 10;
/// Links to `NotoriousMonster`.
pub fn notoriousMonsters(self: @This(), n0: usize) excel.Link(sheets.NotoriousMonster) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

const offsets_1 = [10]u16{ 0, 2, 4, 6, 8, 10, 12, 14, 16, 18 };
