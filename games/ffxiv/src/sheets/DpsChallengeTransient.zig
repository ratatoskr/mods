//! `DpsChallengeTransient`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DpsChallengeTransient = @This();

pub const sheet_name = "DpsChallengeTransient";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd870e208;
pub const Sheet = excel.Typed(DpsChallengeTransient);

row: excel.Row,

/// Links to `InstanceContent`.
pub fn instanceContent(self: @This()) excel.Link(sheets.InstanceContent) {
    return .of(self.row.at(u16, 0));
}
