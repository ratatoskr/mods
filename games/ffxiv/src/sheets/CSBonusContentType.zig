//! `CSBonusContentType`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `ContentType`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CSBonusContentType = @This();

pub const sheet_name = "CSBonusContentType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x903a2e39;
pub const Sheet = excel.Typed(CSBonusContentType);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "ContentType", "Dialogue[0]", "Dialogue[1]", "Dialogue[2]", "Dialogue[3]", "Image", "Level", "Unknown6", "UnlockQuest", "UnlockLink", "ContentFinderCondition" };

pub const dialogue_len = 4;
/// Links to `Addon`.
pub fn dialogue(self: @This(), n0: usize) excel.Link(sheets.Addon) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn image(self: @This()) u32 {
    return self.row.at(u32, 16);
}

/// Links to `Level`.
pub fn level(self: @This()) excel.Link(sheets.Level) {
    return .of(self.row.at(u32, 20));
}

/// Links to `Quest`.
pub fn unlockQuest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 24));
}

pub fn unlockLink(self: @This()) u32 {
    return self.row.at(u32, 28);
}

/// Links to `ContentFinderCondition`.
pub fn contentFinderCondition(self: @This()) excel.Link(sheets.ContentFinderCondition) {
    return .of(self.row.at(u32, 32));
}

/// Links to `ContentType`.
pub fn contentType(self: @This()) excel.Link(sheets.ContentType) {
    return .of(self.row.at(u8, 36));
}

pub fn unknown6(self: @This()) bool {
    return self.row.bitAt(37, 0);
}

const offsets_1 = [4]u16{ 0, 4, 8, 12 };
