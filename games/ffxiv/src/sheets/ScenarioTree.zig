//! `ScenarioTree`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ScenarioTree = @This();

pub const sheet_name = "ScenarioTree";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xca183be8;
pub const Sheet = excel.Typed(ScenarioTree);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Type", "Unknown2", "Addon", "QuestChapter", "Name", "Unknown1", "Unknown0" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `Addon`.
pub fn addon(self: @This()) excel.Link(sheets.Addon) {
    return .of(self.row.at(u32, 4));
}

/// Links to `QuestChapter`.
pub fn questChapter(self: @This()) excel.Link(sheets.QuestChapter) {
    return .of(self.row.at(u32, 8));
}

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn unknown1(self: @This()) i32 {
    return self.row.at(i32, 16);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 20);
}

/// Links to `ScenarioType`.
pub fn @"type"(self: @This()) excel.Link(sheets.ScenarioType) {
    return .of(self.row.at(u8, 22));
}
