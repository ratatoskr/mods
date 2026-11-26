//! `DefaultTalkLipSyncType`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `ActionTimeline`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DefaultTalkLipSyncType = @This();

pub const sheet_name = "DefaultTalkLipSyncType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xda365c51;
pub const Sheet = excel.Typed(DefaultTalkLipSyncType);

row: excel.Row,

/// Links to `ActionTimeline`.
pub fn actionTimeline(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(i32, 0));
}
