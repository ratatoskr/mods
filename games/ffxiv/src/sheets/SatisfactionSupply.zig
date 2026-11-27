//! `SatisfactionSupply`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SatisfactionSupply = @This();

pub const sheet_name = "SatisfactionSupply";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x8c188eb2;
pub const Sheet = excel.Typed(SatisfactionSupply);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Slot", "ProbabilityPercent", "Item", "CollectabilityLow", "CollectabilityMid", "CollectabilityHigh", "Reward", "IsBonus", "FishingSpotId", "SpearFishingSpotId" };

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 0));
}

pub fn collectabilityLow(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn collectabilityMid(self: @This()) u16 {
    return self.row.at(u16, 6);
}

pub fn collectabilityHigh(self: @This()) u16 {
    return self.row.at(u16, 8);
}

/// Links to `SatisfactionSupplyReward`.
pub fn reward(self: @This()) excel.Link(sheets.SatisfactionSupplyReward) {
    return .of(self.row.at(u16, 10));
}

pub fn fishingSpotId(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn spearFishingSpotId(self: @This()) u16 {
    return self.row.at(u16, 14);
}

pub fn slot(self: @This()) u8 {
    return self.row.at(u8, 16);
}

pub fn probabilityPercent(self: @This()) u8 {
    return self.row.at(u8, 17);
}

pub fn isBonus(self: @This()) bool {
    return self.row.bitAt(18, 0);
}
