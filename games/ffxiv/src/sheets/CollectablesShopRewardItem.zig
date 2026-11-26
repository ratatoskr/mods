//! `CollectablesShopRewardItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CollectablesShopRewardItem = @This();

pub const sheet_name = "CollectablesShopRewardItem";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf7e08b71;
pub const Sheet = excel.Typed(CollectablesShopRewardItem);

row: excel.Row,

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 0));
}

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn rewardLow(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn rewardMid(self: @This()) u8 {
    return self.row.at(u8, 9);
}

pub fn rewardHigh(self: @This()) u8 {
    return self.row.at(u8, 10);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 11);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 12);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 13);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(14, 0);
}

pub fn unknown5(self: @This()) bool {
    return self.row.bitAt(14, 1);
}
