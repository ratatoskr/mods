//! `ChocoboRaceTutorial`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ChocoboRaceTutorial = @This();

pub const sheet_name = "ChocoboRaceTutorial";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xef6c7b71;
pub const Sheet = excel.Typed(ChocoboRaceTutorial);

row: excel.Row,

pub const npc_yell_len = 8;
/// Links to `NpcYell`.
pub fn npcYell(self: @This(), n0: usize) excel.Link(sheets.NpcYell) {
    return .of(self.row.at(i32, offsets_1[n0]));
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 32);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 34);
}

const offsets_1 = [8]u16{ 0, 4, 8, 12, 16, 20, 24, 28 };
