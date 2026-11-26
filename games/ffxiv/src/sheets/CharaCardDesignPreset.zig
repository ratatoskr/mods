//! `CharaCardDesignPreset`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CharaCardDesignPreset = @This();

pub const sheet_name = "CharaCardDesignPreset";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x2c94b01f;
pub const Sheet = excel.Typed(CharaCardDesignPreset);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `CharaCardBase`.
pub fn basePlate(self: @This()) excel.Link(sheets.CharaCardBase) {
    return .of(self.row.at(u16, 4));
}

/// Links to `CharaCardDecoration`.
pub fn backing(self: @This()) excel.Link(sheets.CharaCardDecoration) {
    return .of(self.row.at(u16, 6));
}

/// Links to `CharaCardDecoration`.
pub fn patternOverlay(self: @This()) excel.Link(sheets.CharaCardDecoration) {
    return .of(self.row.at(u16, 8));
}

/// Links to `CharaCardDecoration`.
pub fn portraitFrame(self: @This()) excel.Link(sheets.CharaCardDecoration) {
    return .of(self.row.at(u16, 10));
}

/// Links to `CharaCardDecoration`.
pub fn plateFrame(self: @This()) excel.Link(sheets.CharaCardDecoration) {
    return .of(self.row.at(u16, 12));
}

/// Links to `CharaCardDecoration`.
pub fn accent(self: @This()) excel.Link(sheets.CharaCardDecoration) {
    return .of(self.row.at(u16, 14));
}

pub fn sortKey(self: @This()) u16 {
    return self.row.at(u16, 16);
}

/// Links to `CharaCardHeader`.
pub fn topBorder(self: @This()) excel.Link(sheets.CharaCardHeader) {
    return .of(self.row.at(u8, 18));
}

/// Links to `CharaCardHeader`.
pub fn bottomBorder(self: @This()) excel.Link(sheets.CharaCardHeader) {
    return .of(self.row.at(u8, 19));
}
