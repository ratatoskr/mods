//! `MoveTimeline`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Idle`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MoveTimeline = @This();

pub const sheet_name = "MoveTimeline";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf057da9c;
pub const Sheet = excel.Typed(MoveTimeline);

row: excel.Row,

/// Links to `ActionTimeline`.
pub fn idle(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 0));
}

/// Links to `ActionTimeline`.
pub fn moveForward(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 2));
}

/// Links to `ActionTimeline`.
pub fn moveBack(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 4));
}

/// Links to `ActionTimeline`.
pub fn moveLeft(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 6));
}

/// Links to `ActionTimeline`.
pub fn moveRight(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 8));
}

/// Links to `ActionTimeline`.
pub fn moveUp(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 10));
}

/// Links to `ActionTimeline`.
pub fn moveDown(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 12));
}

/// Links to `ActionTimeline`.
pub fn moveTurnLeft(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 14));
}

/// Links to `ActionTimeline`.
pub fn moveTurnRight(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 16));
}

/// Links to `ActionTimeline`.
pub fn extra(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 18));
}
