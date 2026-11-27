//! `CollectablesShopItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CollectablesShopItem = @This();

pub const sheet_name = "CollectablesShopItem";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x5d438d38;
pub const Sheet = excel.Typed(CollectablesShopItem);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Item", "CollectablesShopItemGroup", "LevelMin", "RequiredQuest", "LevelMax", "Stars", "Key", "CollectablesShopRefine", "CollectablesShopRewardScrip" };

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 0));
}

/// Links to `Quest`.
pub fn requiredQuest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 4));
}

pub fn levelMin(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn levelMax(self: @This()) u16 {
    return self.row.at(u16, 10);
}

/// Links to `CollectablesShopRefine`.
pub fn collectablesShopRefine(self: @This()) excel.Link(sheets.CollectablesShopRefine) {
    return .of(self.row.at(u16, 12));
}

/// Links to `CollectablesShopRewardScrip`.
pub fn collectablesShopRewardScrip(self: @This()) excel.Link(sheets.CollectablesShopRewardScrip) {
    return .of(self.row.at(u16, 14));
}

/// Links to `CollectablesShopItemGroup`.
pub fn collectablesShopItemGroup(self: @This()) excel.Link(sheets.CollectablesShopItemGroup) {
    return .of(self.row.at(u8, 16));
}

pub fn stars(self: @This()) u8 {
    return self.row.at(u8, 17);
}

pub fn key(self: @This()) u8 {
    return self.row.at(u8, 18);
}
