//! `MobHuntOrder`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MobHuntOrder = @This();

pub const sheet_name = "MobHuntOrder";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xa9aa9ab5;
pub const Sheet = excel.Typed(MobHuntOrder);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Target", "NeededKills", "Type", "Rank", "MobHuntReward" };

/// Links to `MobHuntTarget`.
pub fn target(self: @This()) excel.Link(sheets.MobHuntTarget) {
    return .of(self.row.at(u16, 0));
}

pub fn neededKills(self: @This()) u8 {
    return self.row.at(u8, 2);
}

pub fn @"type"(self: @This()) u8 {
    return self.row.at(u8, 3);
}

pub fn rank(self: @This()) u8 {
    return self.row.at(u8, 4);
}

/// Links to `MobHuntReward`.
pub fn mobHuntReward(self: @This()) excel.Link(sheets.MobHuntReward) {
    return .of(self.row.at(u8, 5));
}
