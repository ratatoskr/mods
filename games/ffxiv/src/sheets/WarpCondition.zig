//! `WarpCondition`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WarpCondition = @This();

pub const sheet_name = "WarpCondition";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc096f9d0;
pub const Sheet = excel.Typed(WarpCondition);

row: excel.Row,

/// Links to `Quest`.
pub fn requiredQuest1(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 0));
}

/// Links to `Quest`.
pub fn requiredQuest2(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 4));
}

/// Links to `Quest`.
pub fn requiredQuest3(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 8));
}

/// Links to `Quest`.
pub fn requiredQuest4(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 12));
}

pub fn gil(self: @This()) u16 {
    return self.row.at(u16, 16);
}

pub fn questReward(self: @This()) u16 {
    return self.row.at(u16, 18);
}

pub fn classLevel(self: @This()) u16 {
    return self.row.at(u16, 20);
}

pub fn completeParam(self: @This()) u8 {
    return self.row.at(u8, 22);
}
