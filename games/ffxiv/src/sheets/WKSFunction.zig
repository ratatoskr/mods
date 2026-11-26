//! `WKSFunction`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSFunction = @This();

pub const sheet_name = "WKSFunction";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xacf54e03;
pub const Sheet = excel.Typed(WKSFunction);

row: excel.Row,

pub const required_quests0_len = 4;
/// Required quest needed for function to return true
/// Links to `Quest`.
pub fn requiredQuests0(self: @This(), n0: usize) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

pub const required_quests1_len = 4;
/// Required quest needed for function to return true
/// Links to `Quest`.
pub fn requiredQuests1(self: @This(), n0: usize) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, offsets_2[n0]));
}

pub const required_quests2_len = 4;
/// Best guess for now as no references are easily found in the game files
/// Links to `Quest`.
pub fn requiredQuests2(self: @This(), n0: usize) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, offsets_3[n0]));
}

pub const required_dev_grade_len = 4;
/// Needs this grade to be completed for function to be valid. Game checks for WKSManager.DevGrade < RequiredDevGrade[]
/// Links to `WKSDevGrade`.
pub fn requiredDevGrade(self: @This(), n0: usize) excel.Link(sheets.WKSDevGrade) {
    return .of(self.row.at(u8, offsets_4[n0]));
}

pub const unknown12_len = 4;
/// Seems to only control one function tree for now relating to something in WKSManager but is also slated to check for '- 2 >= 2' and fail
pub fn unknown12(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_5[n0]);
}

const offsets_1 = [4]u16{ 0, 4, 8, 12 };
const offsets_2 = [4]u16{ 16, 20, 24, 28 };
const offsets_3 = [4]u16{ 32, 36, 40, 44 };
const offsets_4 = [4]u16{ 48, 49, 50, 51 };
const offsets_5 = [4]u16{ 52, 53, 54, 55 };
