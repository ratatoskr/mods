//! `Guide`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Guide = @This();

pub const sheet_name = "Guide";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x2020acf6;
pub const Sheet = excel.Typed(Guide);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "GuideTitle", "GuidePage" };

/// Links to `GuideTitle`.
pub fn guideTitle(self: @This()) excel.Link(sheets.GuideTitle) {
    return .of(self.row.at(u16, 0));
}

/// Links to `GuidePage`.
pub fn guidePage(self: @This()) excel.Link(sheets.GuidePage) {
    return .of(self.row.at(u16, 2));
}
