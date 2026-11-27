//! `GathererCrafterLvAdjustTable`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GathererCrafterLvAdjustTable = @This();

pub const sheet_name = "GathererCrafterLvAdjustTable";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x64a88f98;
pub const Sheet = excel.Typed(GathererCrafterLvAdjustTable);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "RecipeLevel", "Unknown1", "CrafterLevel", "GathererLevel", "FisherLevel" };

/// Links to `RecipeLevelTable`.
pub fn recipeLevel(self: @This()) excel.Link(sheets.RecipeLevelTable) {
    return .of(self.row.at(u16, 0));
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 2);
}

/// Links to `ItemLevel`.
pub fn crafterLevel(self: @This()) excel.Link(sheets.ItemLevel) {
    return .of(self.row.at(u16, 4));
}

/// Links to `ItemLevel`.
pub fn gathererLevel(self: @This()) excel.Link(sheets.ItemLevel) {
    return .of(self.row.at(u16, 6));
}

/// Links to `ItemLevel`.
pub fn fisherLevel(self: @This()) excel.Link(sheets.ItemLevel) {
    return .of(self.row.at(u16, 8));
}
