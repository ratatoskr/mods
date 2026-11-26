//! `ContentRouletteRoleBonus`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ContentRouletteRoleBonus = @This();

pub const sheet_name = "ContentRouletteRoleBonus";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x8c1eab22;
pub const Sheet = excel.Typed(ContentRouletteRoleBonus);

row: excel.Row,

pub const item_len = 2;
/// Links to `Item`.
pub fn item(self: @This(), n0: usize) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

/// Formula: BaseExperience * ParamGrow.ScaledQuestXP * ParamGrow.QuestExpModifier / 1000
pub fn baseExperience(self: @This()) u16 {
    return self.row.at(u16, 8);
}

/// Formula: InstanceContent.InstanceClearGil * GilMultiplier / 1000
pub fn gilMultiplier(self: @This()) u16 {
    return self.row.at(u16, 10);
}

/// Formula: CurrentLevel * GCSealsMultiplier / 1000
pub fn gcSealsMultiplier(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn currencyA(self: @This()) u16 {
    return self.row.at(u16, 14);
}

pub fn currencyB(self: @This()) u16 {
    return self.row.at(u16, 16);
}

pub fn currencyC(self: @This()) u16 {
    return self.row.at(u16, 18);
}

pub const item_quantity_len = 2;
pub fn itemQuantity(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_2[n0]);
}

pub const item_max_level_condition_len = 2;
/// 0 = Always rewarded
/// 1 = Character has reached current expansions max level
/// 2 = Character has reached at least 50
/// 3 = Character has reached at least 60
/// 4 = Character has reached at least 70
/// 5 = Character has reached at least 80
/// 6 = Character has reached at least 90
pub fn itemMaxLevelCondition(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_3[n0]);
}

const offsets_1 = [2]u16{ 0, 4 };
const offsets_2 = [2]u16{ 20, 21 };
const offsets_3 = [2]u16{ 22, 23 };
