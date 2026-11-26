//! `CSBonusContent`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Content0`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CSBonusContent = @This();

pub const sheet_name = "CSBonusContent";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf8d2be91;
pub const Sheet = excel.Typed(CSBonusContent);

row: excel.Row,

pub fn score1(self: @This()) i32 {
    return self.row.at(i32, 0);
}

pub fn score2(self: @This()) i32 {
    return self.row.at(i32, 4);
}

pub fn score3(self: @This()) i32 {
    return self.row.at(i32, 8);
}

pub fn score4(self: @This()) i32 {
    return self.row.at(i32, 12);
}

pub fn score5(self: @This()) i32 {
    return self.row.at(i32, 16);
}

/// Links to `CSBonusContentIdentifier`.
pub fn content0(self: @This()) excel.Link(sheets.CSBonusContentIdentifier) {
    return .of(self.row.at(u16, 20));
}

/// Links to `CSBonusContentIdentifier`.
pub fn content1(self: @This()) excel.Link(sheets.CSBonusContentIdentifier) {
    return .of(self.row.at(u16, 22));
}

pub fn score0(self: @This()) u16 {
    return self.row.at(u16, 24);
}

/// Links to `CSBonusContentType`.
pub fn contentType(self: @This()) excel.Link(sheets.CSBonusContentType) {
    return .of(self.row.at(u8, 26));
}

pub fn rewardCount0(self: @This()) u8 {
    return self.row.at(u8, 27);
}

pub fn rewardCount1(self: @This()) u8 {
    return self.row.at(u8, 28);
}

pub fn rewardCount2(self: @This()) u8 {
    return self.row.at(u8, 29);
}

pub fn rewardCount3(self: @This()) u8 {
    return self.row.at(u8, 30);
}

pub fn rewardCount4(self: @This()) u8 {
    return self.row.at(u8, 31);
}
