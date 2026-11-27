//! `Perform`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Perform = @This();

pub const sheet_name = "Perform";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x7bf81fa9;
pub const Sheet = excel.Typed(Perform);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "Unknown1", "ModelKey", "AnimationStart", "AnimationEnd", "AnimationIdle", "AnimationPlay01", "AnimationPlay02", "UnlockLink", "Instrument", "Icon", "Transient", "PerformGroup" };

/// Links to `ActionTimeline`.
pub fn animationPlay01(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 0));
}

/// Links to `ActionTimeline`.
pub fn animationPlay02(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 2));
}

pub fn instrument(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn modelKey(self: @This()) u64 {
    return self.row.at(u64, 8);
}

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(16);
}

pub fn unlockLink(self: @This()) i32 {
    return self.row.at(i32, 20);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 24);
}

/// Links to `ActionTimeline`.
pub fn animationStart(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 28));
}

/// Links to `ActionTimeline`.
pub fn animationEnd(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 30));
}

/// Links to `ActionTimeline`.
pub fn animationIdle(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 32));
}

/// Links to `PerformTransient`.
pub fn transient(self: @This()) excel.Link(sheets.PerformTransient) {
    return .of(self.row.at(u8, 34));
}

/// Links to `PerformGroup`.
pub fn performGroup(self: @This()) excel.Link(sheets.PerformGroup) {
    return .of(self.row.at(u8, 35));
}

pub fn unknown1(self: @This()) bool {
    return self.row.bitAt(36, 0);
}
