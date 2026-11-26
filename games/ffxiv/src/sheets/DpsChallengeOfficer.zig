//! `DpsChallengeOfficer`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DpsChallengeOfficer = @This();

pub const sheet_name = "DpsChallengeOfficer";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x786cf56a;
pub const Sheet = excel.Typed(DpsChallengeOfficer);

row: excel.Row,

pub const challenge_name_len = 26;
/// Links to `DpsChallenge`.
pub fn challengeName(self: @This(), n0: usize) excel.Link(sheets.DpsChallenge) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

/// Links to `Quest`.
pub fn unlockQuest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 52));
}

const offsets_1 = [26]u16{ 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50 };
