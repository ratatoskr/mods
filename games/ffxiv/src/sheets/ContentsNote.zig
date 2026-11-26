//! `ContentsNote`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ContentsNote = @This();

pub const sheet_name = "ContentsNote";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x748963d8;
pub const Sheet = excel.Typed(ContentsNote);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

/// Links to `Quest`.
pub fn reqUnlock(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 8));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 12);
}

pub fn requiredAmount(self: @This()) i32 {
    return self.row.at(i32, 16);
}

pub fn expMultiplier(self: @This()) i32 {
    return self.row.at(i32, 20);
}

pub fn gilRward(self: @This()) i32 {
    return self.row.at(i32, 24);
}

pub fn expCap(self: @This()) i32 {
    return self.row.at(i32, 28);
}

pub fn levelUnlock(self: @This()) u16 {
    return self.row.at(u16, 32);
}

/// Links to `HowTo`.
pub fn howTo(self: @This()) excel.Link(sheets.HowTo) {
    return .of(self.row.at(u16, 34));
}

/// Links to `ContentsNoteCategory`.
pub fn contentType(self: @This()) excel.Link(sheets.ContentsNoteCategory) {
    return .of(self.row.at(u8, 36));
}

pub fn menuOrder(self: @This()) u8 {
    return self.row.at(u8, 37);
}

pub fn reward0(self: @This()) u8 {
    return self.row.at(u8, 38);
}

pub fn reward1(self: @This()) u8 {
    return self.row.at(u8, 39);
}
