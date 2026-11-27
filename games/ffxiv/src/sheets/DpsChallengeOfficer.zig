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

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "UnlockQuest", "ChallengeName[0]", "ChallengeName[1]", "ChallengeName[2]", "ChallengeName[3]", "ChallengeName[4]", "ChallengeName[5]", "ChallengeName[6]", "ChallengeName[7]", "ChallengeName[8]", "ChallengeName[9]", "ChallengeName[10]", "ChallengeName[11]", "ChallengeName[12]", "ChallengeName[13]", "ChallengeName[14]", "ChallengeName[15]", "ChallengeName[16]", "ChallengeName[17]", "ChallengeName[18]", "ChallengeName[19]", "ChallengeName[20]", "ChallengeName[21]", "ChallengeName[22]", "ChallengeName[23]", "ChallengeName[24]", "ChallengeName[25]" };

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
