//! `HWDLevelChangeDeception`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Image`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HWDLevelChangeDeception = @This();

pub const sheet_name = "HWDLevelChangeDeception";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xda365c51;
pub const Sheet = excel.Typed(HWDLevelChangeDeception);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{"Image"};

/// Links to `ScreenImage`.
pub fn image(self: @This()) excel.Link(sheets.ScreenImage) {
    return .of(self.row.at(i32, 0));
}
