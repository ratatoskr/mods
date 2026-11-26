//! `EventItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Singular`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EventItem = @This();

pub const sheet_name = "EventItem";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x2a1d4fb2;
pub const Sheet = excel.Typed(EventItem);

row: excel.Row,

pub fn singular(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn plural(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn adjective(self: @This()) i8 {
    return self.row.at(i8, 12);
}

pub fn possessivePronoun(self: @This()) i8 {
    return self.row.at(i8, 13);
}

pub fn startsWithVowel(self: @This()) i8 {
    return self.row.at(i8, 14);
}

pub fn countability(self: @This()) i8 {
    return self.row.at(i8, 15);
}

pub fn pronoun(self: @This()) i8 {
    return self.row.at(i8, 16);
}

pub fn article(self: @This()) i8 {
    return self.row.at(i8, 17);
}

pub fn unknown1(self: @This()) bool {
    return self.row.bitAt(18, 0);
}

/// Links to `Quest`.
pub fn quest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 20));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u16 {
    return self.row.at(u16, 24);
}

/// Links to `Action`.
pub fn action(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(u16, 26));
}

pub fn stackSize(self: @This()) u8 {
    return self.row.at(u8, 28);
}

/// Links to `EventItemCategory`.
pub fn category(self: @This()) excel.Link(sheets.EventItemCategory) {
    return .of(self.row.at(u8, 29));
}

pub fn castTime(self: @This()) u8 {
    return self.row.at(u8, 30);
}

/// Links to `EventItemCastTimeline`.
pub fn castTimeline(self: @This()) excel.Link(sheets.EventItemCastTimeline) {
    return .of(self.row.at(u8, 31));
}

pub fn timeline(self: @This()) u8 {
    return self.row.at(u8, 32);
}
