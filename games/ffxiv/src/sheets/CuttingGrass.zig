//! `CuttingGrass`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CuttingGrass = @This();

pub const sheet_name = "CuttingGrass";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x534143bc;
pub const Sheet = excel.Typed(CuttingGrass);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "PopRange", "Unknown10", "Duration", "Unknown3", "Unknown4", "ScreenImageStart", "ScreenImageEnd", "Action[0]", "Action[1]", "Action[2]" };

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Center of the playing area.
pub fn popRange(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// How much time the player has at the start of the game, in seconds.
pub fn duration(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn unknown3(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn unknown4(self: @This()) u32 {
    return self.row.at(u32, 16);
}

/// Links to `ScreenImage`.
pub fn screenImageStart(self: @This()) excel.Link(sheets.ScreenImage) {
    return .of(self.row.at(u32, 20));
}

/// Links to `ScreenImage`.
pub fn screenImageEnd(self: @This()) excel.Link(sheets.ScreenImage) {
    return .of(self.row.at(u32, 24));
}

pub const action_len = 3;
/// Links to `Action`.
pub fn action(self: @This(), n0: usize) excel.Link(sheets.Action) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

pub fn unknown10(self: @This()) i32 {
    return self.row.at(i32, 40);
}

const offsets_1 = [3]u16{ 28, 32, 36 };
