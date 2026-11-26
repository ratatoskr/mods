//! `VVDVoteRoute`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Title`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const VVDVoteRoute = @This();

pub const sheet_name = "VVDVoteRoute";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x63c20db3;
pub const Sheet = excel.Typed(VVDVoteRoute);

row: excel.Row,

/// Links to `VVDVoteRouteLabel`.
pub fn title(self: @This()) excel.Link(sheets.VVDVoteRouteLabel) {
    return .of(self.row.at(i32, 0));
}

pub const options_len = 4;
/// Links to `VVDVoteRouteLabel`.
pub fn options(self: @This(), n0: usize) excel.Link(sheets.VVDVoteRouteLabel) {
    return .of(self.row.at(i32, offsets_1[n0]));
}

const offsets_1 = [4]u16{ 4, 8, 12, 16 };
