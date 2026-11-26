//! `EventAction`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EventAction = @This();

pub const sheet_name = "EventAction";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x1c60d673;
pub const Sheet = excel.Typed(EventAction);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u16 {
    return self.row.at(u16, 4);
}

/// Links to `ActionTimeline`.
pub fn startAnimation(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 6));
}

/// Links to `ActionTimeline`.
pub fn loopAnimation(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 8));
}

/// Links to `ActionTimeline`.
pub fn endAnimation(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 10));
}

pub fn castTime(self: @This()) u8 {
    return self.row.at(u8, 12);
}
