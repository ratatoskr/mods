//! `EventTutorial`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Singular`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EventTutorial = @This();

pub const sheet_name = "EventTutorial";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc46ab06d;
pub const Sheet = excel.Typed(EventTutorial);

row: excel.Row,

pub fn singular(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn plural(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unlockLink(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub const pages_len = 8;
/// Links to `EventTutorialPage`.
pub fn pages(self: @This(), n0: usize) excel.Link(sheets.EventTutorialPage) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

const offsets_1 = [8]u16{ 12, 14, 16, 18, 20, 22, 24, 26 };
