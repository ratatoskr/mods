//! `TripleTriad`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TripleTriad = @This();

pub const sheet_name = "TripleTriad";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x646dde20;
pub const Sheet = excel.Typed(TripleTriad);

row: excel.Row,

pub const item_possible_reward_len = 4;
/// Links to `Item`.
pub fn itemPossibleReward(self: @This(), n0: usize) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

pub const previous_quest_len = 3;
/// Links to `Quest`.
pub fn previousQuest(self: @This(), n0: usize) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, offsets_2[n0]));
}

/// Links to `DefaultTalk`.
pub fn defaultTalkChallenge(self: @This()) excel.Link(sheets.DefaultTalk) {
    return .of(self.row.at(u32, 28));
}

/// Links to `DefaultTalk`.
pub fn defaultTalkUnavailable(self: @This()) excel.Link(sheets.DefaultTalk) {
    return .of(self.row.at(u32, 32));
}

/// Links to `DefaultTalk`.
pub fn defaultTalkNPCWin(self: @This()) excel.Link(sheets.DefaultTalk) {
    return .of(self.row.at(u32, 36));
}

/// Links to `DefaultTalk`.
pub fn defaultTalkDraw(self: @This()) excel.Link(sheets.DefaultTalk) {
    return .of(self.row.at(u32, 40));
}

/// Links to `DefaultTalk`.
pub fn defaultTalkPCWin(self: @This()) excel.Link(sheets.DefaultTalk) {
    return .of(self.row.at(u32, 44));
}

pub const triple_triad_card_fixed_len = 5;
/// Links to `TripleTriadCard`.
pub fn tripleTriadCardFixed(self: @This(), n0: usize) excel.Link(sheets.TripleTriadCard) {
    return .of(self.row.at(u16, offsets_3[n0]));
}

pub const triple_triad_card_variable_len = 5;
/// Links to `TripleTriadCard`.
pub fn tripleTriadCardVariable(self: @This(), n0: usize) excel.Link(sheets.TripleTriadCard) {
    return .of(self.row.at(u16, offsets_4[n0]));
}

pub fn fee(self: @This()) u16 {
    return self.row.at(u16, 68);
}

pub fn startTime(self: @This()) u16 {
    return self.row.at(u16, 70);
}

pub fn endTime(self: @This()) u16 {
    return self.row.at(u16, 72);
}

pub const triple_triad_rule_len = 2;
/// Links to `TripleTriadRule`.
pub fn tripleTriadRule(self: @This(), n0: usize) excel.Link(sheets.TripleTriadRule) {
    return .of(self.row.at(u8, offsets_5[n0]));
}

pub fn previousQuestJoin(self: @This()) u8 {
    return self.row.at(u8, 76);
}

pub fn usesRegionalRules(self: @This()) bool {
    return self.row.bitAt(77, 0);
}

pub fn unknown0(self: @This()) bool {
    return self.row.bitAt(77, 1);
}

const offsets_1 = [4]u16{ 0, 4, 8, 12 };
const offsets_2 = [3]u16{ 16, 20, 24 };
const offsets_3 = [5]u16{ 48, 50, 52, 54, 56 };
const offsets_4 = [5]u16{ 58, 60, 62, 64, 66 };
const offsets_5 = [2]u16{ 74, 75 };
