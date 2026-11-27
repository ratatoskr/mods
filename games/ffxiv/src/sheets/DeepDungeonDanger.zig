//! `DeepDungeonDanger`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DeepDungeonDanger = @This();

pub const sheet_name = "DeepDungeonDanger";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdc23efe7;
pub const Sheet = excel.Typed(DeepDungeonDanger);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "ScreenImage", "LogMessage", "FloorEffectUI" };

/// Links to `ScreenImage`.
pub fn screenImage(self: @This()) excel.Link(sheets.ScreenImage) {
    return .of(self.row.at(u16, 0));
}

/// Links to `LogMessage`.
pub fn logMessage(self: @This()) excel.Link(sheets.LogMessage) {
    return .of(self.row.at(u16, 2));
}

/// Links to `DeepDungeonFloorEffectUI`.
pub fn floorEffectUI(self: @This()) excel.Link(sheets.DeepDungeonFloorEffectUI) {
    return .of(self.row.at(u16, 4));
}
