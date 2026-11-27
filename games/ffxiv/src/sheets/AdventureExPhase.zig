//! `AdventureExPhase`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AdventureExPhase = @This();

pub const sheet_name = "AdventureExPhase";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x2ebeea9f;
pub const Sheet = excel.Typed(AdventureExPhase);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Quest", "AdventureBegin", "AdventureEnd", "Expansion", "AllVistasCompletedScreenImage" };

/// Links to `Quest`.
pub fn quest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 0));
}

/// Links to `Adventure`.
pub fn adventureBegin(self: @This()) excel.Link(sheets.Adventure) {
    return .of(self.row.at(u32, 4));
}

/// Links to `Adventure`.
pub fn adventureEnd(self: @This()) excel.Link(sheets.Adventure) {
    return .of(self.row.at(u32, 8));
}

/// Links to `ScreenImage`.
pub fn allVistasCompletedScreenImage(self: @This()) excel.Link(sheets.ScreenImage) {
    return .of(self.row.at(u32, 12));
}

/// Links to `ExVersion`.
pub fn expansion(self: @This()) excel.Link(sheets.ExVersion) {
    return .of(self.row.at(u8, 16));
}
