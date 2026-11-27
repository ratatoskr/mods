//! `GrandCompanyRank`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GrandCompanyRank = @This();

pub const sheet_name = "GrandCompanyRank";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x939f7424;
pub const Sheet = excel.Typed(GrandCompanyRank);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Tier", "Order", "MaxSeals", "RequiredSeals", "IconMaelstrom", "IconSerpents", "IconFlames", "QuestMaelstrom", "QuestSerpents", "QuestFlames", "RequiredHuntingLogRank" };

pub fn maxSeals(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn requiredSeals(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn iconMaelstrom(self: @This()) i32 {
    return self.row.at(i32, 8);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn iconSerpents(self: @This()) i32 {
    return self.row.at(i32, 12);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn iconFlames(self: @This()) i32 {
    return self.row.at(i32, 16);
}

/// Links to `Quest`.
pub fn questMaelstrom(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(i32, 20));
}

/// Links to `Quest`.
pub fn questSerpents(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(i32, 24));
}

/// Links to `Quest`.
pub fn questFlames(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(i32, 28));
}

pub fn tier(self: @This()) u8 {
    return self.row.at(u8, 32);
}

pub fn order(self: @This()) u8 {
    return self.row.at(u8, 33);
}

pub fn requiredHuntingLogRank(self: @This()) u8 {
    return self.row.at(u8, 34);
}
