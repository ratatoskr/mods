//! `GatheringPointBonus`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GatheringPointBonus = @This();

pub const sheet_name = "GatheringPointBonus";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xcd832c29;
pub const Sheet = excel.Typed(GatheringPointBonus);

row: excel.Row,

pub fn conditionValue(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn bonusValue(self: @This()) u16 {
    return self.row.at(u16, 10);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 12);
}

/// Links to `GatheringCondition`.
pub fn condition(self: @This()) excel.Link(sheets.GatheringCondition) {
    return .of(self.row.at(u8, 14));
}

/// Links to `GatheringPointBonusType`.
pub fn bonusType(self: @This()) excel.Link(sheets.GatheringPointBonusType) {
    return .of(self.row.at(u8, 15));
}

pub fn unknown3(self: @This()) bool {
    return self.row.bitAt(16, 0);
}
