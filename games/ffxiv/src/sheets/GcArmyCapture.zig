//! `GcArmyCapture`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GcArmyCapture = @This();

pub const sheet_name = "GcArmyCapture";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x95ba3e0b;
pub const Sheet = excel.Typed(GcArmyCapture);

row: excel.Row,

/// Links to `ContentFinderCondition`.
pub fn content(self: @This()) excel.Link(sheets.ContentFinderCondition) {
    return .of(self.row.at(u32, 0));
}

pub fn unknown1(self: @This()) i32 {
    return self.row.at(i32, 4);
}

pub fn itemLevelRequired(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn itemLevelSync(self: @This()) u16 {
    return self.row.at(u16, 10);
}

pub fn requiredSeals(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn rewardExperience(self: @This()) u16 {
    return self.row.at(u16, 14);
}

pub fn classJobLevelRequired(self: @This()) u8 {
    return self.row.at(u8, 16);
}

pub fn classJobLevelSync(self: @This()) u8 {
    return self.row.at(u8, 17);
}
