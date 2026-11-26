//! `PublicContent`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PublicContent = @This();

pub const sheet_name = "PublicContent";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x33f0d49f;
pub const Sheet = excel.Typed(PublicContent);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn mapIcon(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// Links to `PublicContentTextData`.
pub fn textDataStart(self: @This()) excel.Link(sheets.PublicContentTextData) {
    return .of(self.row.at(u32, 8));
}

/// Links to `PublicContentTextData`.
pub fn textDataEnd(self: @This()) excel.Link(sheets.PublicContentTextData) {
    return .of(self.row.at(u32, 12));
}

/// Links to `PublicContentCutscene`.
pub fn startCutscene(self: @This()) excel.Link(sheets.PublicContentCutscene) {
    return .of(self.row.at(u32, 16));
}

pub fn lgbEventRange(self: @This()) u32 {
    return self.row.at(u32, 20);
}

pub fn lgbPopRange(self: @This()) u32 {
    return self.row.at(u32, 24);
}

/// Links to `PublicContentCutscene`.
pub fn endCutscene(self: @This()) excel.Link(sheets.PublicContentCutscene) {
    return .of(self.row.at(u32, 28));
}

pub fn timeLimit(self: @This()) u16 {
    return self.row.at(u16, 32);
}

/// Links to `ContentFinderCondition`.
pub fn contentFinderCondition(self: @This()) excel.Link(sheets.ContentFinderCondition) {
    return .of(self.row.at(u16, 34));
}

/// Links by `Type`: 3 to `Eureka`, 5 to `GFateClimbing2Content`.
pub fn additionalData(self: @This()) u16 {
    return self.row.at(u16, 36);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 38);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 40);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 42);
}

pub fn unknown3(self: @This()) u16 {
    return self.row.at(u16, 44);
}

pub fn unknown5(self: @This()) u16 {
    return self.row.at(u16, 46);
}

/// Links to `PublicContentType`.
pub fn @"type"(self: @This()) excel.Link(sheets.PublicContentType) {
    return .of(self.row.at(u8, 48));
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 49);
}
