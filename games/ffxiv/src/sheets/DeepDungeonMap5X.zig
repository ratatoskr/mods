//! `DeepDungeonMap5X`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DeepDungeonMap5X = @This();

pub const sheet_name = "DeepDungeonMap5X";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x64a88f98;
pub const Sheet = excel.Typed(DeepDungeonMap5X);

row: excel.Row,

pub const deep_dungeon_room_len = 5;
/// Links to `DeepDungeonRoom`.
pub fn deepDungeonRoom(self: @This(), n0: usize) excel.Link(sheets.DeepDungeonRoom) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

const offsets_1 = [5]u16{ 0, 2, 4, 6, 8 };
