//! `BNpcCustomize`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BNpcCustomize = @This();

pub const sheet_name = "BNpcCustomize";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x18f060d4;
pub const Sheet = excel.Typed(BNpcCustomize);

row: excel.Row,

/// Links to `Race`.
pub fn race(self: @This()) excel.Link(sheets.Race) {
    return .of(self.row.at(u8, 0));
}

pub fn gender(self: @This()) u8 {
    return self.row.at(u8, 1);
}

pub fn bodyType(self: @This()) u8 {
    return self.row.at(u8, 2);
}

pub fn height(self: @This()) u8 {
    return self.row.at(u8, 3);
}

/// Links to `Tribe`.
pub fn tribe(self: @This()) excel.Link(sheets.Tribe) {
    return .of(self.row.at(u8, 4));
}

pub fn face(self: @This()) u8 {
    return self.row.at(u8, 5);
}

pub fn hairStyle(self: @This()) u8 {
    return self.row.at(u8, 6);
}

pub fn hairHighlight(self: @This()) u8 {
    return self.row.at(u8, 7);
}

pub fn skinColor(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn eyeHeterochromia(self: @This()) u8 {
    return self.row.at(u8, 9);
}

pub fn hairColor(self: @This()) u8 {
    return self.row.at(u8, 10);
}

pub fn hairHighlightColor(self: @This()) u8 {
    return self.row.at(u8, 11);
}

pub fn facialFeature(self: @This()) u8 {
    return self.row.at(u8, 12);
}

pub fn facialFeatureColor(self: @This()) u8 {
    return self.row.at(u8, 13);
}

pub fn eyebrows(self: @This()) u8 {
    return self.row.at(u8, 14);
}

pub fn eyeColor(self: @This()) u8 {
    return self.row.at(u8, 15);
}

pub fn eyeShape(self: @This()) u8 {
    return self.row.at(u8, 16);
}

pub fn nose(self: @This()) u8 {
    return self.row.at(u8, 17);
}

pub fn jaw(self: @This()) u8 {
    return self.row.at(u8, 18);
}

pub fn mouth(self: @This()) u8 {
    return self.row.at(u8, 19);
}

pub fn lipColor(self: @This()) u8 {
    return self.row.at(u8, 20);
}

pub fn bustOrTone1(self: @This()) u8 {
    return self.row.at(u8, 21);
}

pub fn extraFeature1(self: @This()) u8 {
    return self.row.at(u8, 22);
}

pub fn extraFeature2OrBust(self: @This()) u8 {
    return self.row.at(u8, 23);
}

pub fn facePaint(self: @This()) u8 {
    return self.row.at(u8, 24);
}

pub fn facePaintColor(self: @This()) u8 {
    return self.row.at(u8, 25);
}
