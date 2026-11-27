//! `RecipeLevelTable`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const RecipeLevelTable = @This();

pub const sheet_name = "RecipeLevelTable";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x463c491f;
pub const Sheet = excel.Typed(RecipeLevelTable);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "ClassJobLevel", "Stars", "SuggestedCraftsmanship", "Difficulty", "Quality", "ProgressDivider", "QualityDivider", "ProgressModifier", "QualityModifier", "Durability", "ConditionsFlag" };

pub fn quality(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn suggestedCraftsmanship(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn difficulty(self: @This()) u16 {
    return self.row.at(u16, 6);
}

pub fn durability(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn conditionsFlag(self: @This()) u16 {
    return self.row.at(u16, 10);
}

pub fn classJobLevel(self: @This()) u8 {
    return self.row.at(u8, 12);
}

pub fn stars(self: @This()) u8 {
    return self.row.at(u8, 13);
}

pub fn progressDivider(self: @This()) u8 {
    return self.row.at(u8, 14);
}

pub fn qualityDivider(self: @This()) u8 {
    return self.row.at(u8, 15);
}

pub fn progressModifier(self: @This()) u8 {
    return self.row.at(u8, 16);
}

pub fn qualityModifier(self: @This()) u8 {
    return self.row.at(u8, 17);
}
