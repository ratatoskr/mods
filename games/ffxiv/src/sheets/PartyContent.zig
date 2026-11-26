//! `PartyContent`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `ContentFinderCondition`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PartyContent = @This();

pub const sheet_name = "PartyContent";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x0fe3ae35;
pub const Sheet = excel.Typed(PartyContent);

row: excel.Row,

pub const lgb_event_object_len = 9;
pub fn lgbEventObject(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_1[n0]);
}

pub const lgb_event_range_len = 9;
pub fn lgbEventRange(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_2[n0]);
}

pub const lgb_event_object2_len = 9;
pub fn lgbEventObject2(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_3[n0]);
}

/// Links to `PartyContentTextData`.
pub fn textDataStart(self: @This()) excel.Link(sheets.PartyContentTextData) {
    return .of(self.row.at(u32, 108));
}

/// Links to `PartyContentTextData`.
pub fn textDataEnd(self: @This()) excel.Link(sheets.PartyContentTextData) {
    return .of(self.row.at(u32, 112));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn image(self: @This()) u32 {
    return self.row.at(u32, 116);
}

pub fn timeLimit(self: @This()) u16 {
    return self.row.at(u16, 120);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 122);
}

/// Links to `ContentFinderCondition`.
pub fn contentFinderCondition(self: @This()) excel.Link(sheets.ContentFinderCondition) {
    return .of(self.row.at(u16, 124));
}

pub fn key(self: @This()) u8 {
    return self.row.at(u8, 126);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 127);
}

pub fn name(self: @This()) bool {
    return self.row.bitAt(128, 0);
}

const offsets_1 = [9]u16{ 0, 4, 8, 12, 16, 20, 24, 28, 32 };
const offsets_2 = [9]u16{ 36, 40, 44, 48, 52, 56, 60, 64, 68 };
const offsets_3 = [9]u16{ 72, 76, 80, 84, 88, 92, 96, 100, 104 };
