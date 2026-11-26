//! `ChocoboRaceRanking`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ChocoboRaceRanking = @This();

pub const sheet_name = "ChocoboRaceRanking";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd870e208;
pub const Sheet = excel.Typed(ChocoboRaceRanking);

row: excel.Row,

/// Links to `BGM`.
pub fn bgm(self: @This()) excel.Link(sheets.BGM) {
    return .of(self.row.at(u16, 0));
}
