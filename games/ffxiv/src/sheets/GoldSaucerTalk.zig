//! `GoldSaucerTalk`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Message`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GoldSaucerTalk = @This();

pub const sheet_name = "GoldSaucerTalk";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x49cf08f4;
pub const Sheet = excel.Typed(GoldSaucerTalk);

row: excel.Row,

pub fn message(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub const choices_text_len = 10;
pub fn choicesText(self: @This(), n0: usize) []const u8 {
    return self.row.stringAt(offsets_1[n0]);
}

/// The next GoldSaucerTalk message.
/// Links to `GoldSaucerTalk`.
pub fn nextTalk(self: @This()) excel.Link(sheets.GoldSaucerTalk) {
    return .of(self.row.at(u16, 44));
}

/// Links to `ActionTimeline`.
pub fn actionTimeline(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 46));
}

pub const choices_talk_len = 10;
/// The next GoldSaucerTalk for the ChoicesText of the same index.
/// Links to `GoldSaucerTalk`.
pub fn choicesTalk(self: @This(), n0: usize) excel.Link(sheets.GoldSaucerTalk) {
    return .of(self.row.at(u16, offsets_2[n0]));
}

pub fn unknown23(self: @This()) u8 {
    return self.row.at(u8, 68);
}

pub fn unknown24(self: @This()) u8 {
    return self.row.at(u8, 69);
}

pub fn unknown25(self: @This()) u8 {
    return self.row.at(u8, 70);
}

pub fn unknown26(self: @This()) bool {
    return self.row.bitAt(71, 0);
}

pub fn unknown27(self: @This()) bool {
    return self.row.bitAt(71, 1);
}

const offsets_1 = [10]u16{ 4, 8, 12, 16, 20, 24, 28, 32, 36, 40 };
const offsets_2 = [10]u16{ 48, 50, 52, 54, 56, 58, 60, 62, 64, 66 };
