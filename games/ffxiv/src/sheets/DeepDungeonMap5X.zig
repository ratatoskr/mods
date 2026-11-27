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

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "DeepDungeonRoom[0]", "DeepDungeonRoom[1]", "DeepDungeonRoom[2]", "DeepDungeonRoom[3]", "DeepDungeonRoom[4]" };

pub const deep_dungeon_room_len = 5;
/// Links to `DeepDungeonRoom`.
pub fn deepDungeonRoom(self: @This(), n0: usize) excel.Link(sheets.DeepDungeonRoom) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

const offsets_1 = [5]u16{ 0, 2, 4, 6, 8 };
