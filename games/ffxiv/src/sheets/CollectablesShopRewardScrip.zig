//! `CollectablesShopRewardScrip`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Currency`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CollectablesShopRewardScrip = @This();

pub const sheet_name = "CollectablesShopRewardScrip";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x0c33ce97;
pub const Sheet = excel.Typed(CollectablesShopRewardScrip);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Currency", "LowReward", "MidReward", "HighReward", "ExpRatioLow", "ExpRatioMid", "ExpRatioHigh" };

pub fn currency(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn lowReward(self: @This()) u16 {
    return self.row.at(u16, 2);
}

pub fn midReward(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn highReward(self: @This()) u16 {
    return self.row.at(u16, 6);
}

pub fn expRatioLow(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn expRatioMid(self: @This()) u16 {
    return self.row.at(u16, 10);
}

pub fn expRatioHigh(self: @This()) u16 {
    return self.row.at(u16, 12);
}
