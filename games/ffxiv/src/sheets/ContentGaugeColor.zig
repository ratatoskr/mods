//! `ContentGaugeColor`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ContentGaugeColor = @This();

pub const sheet_name = "ContentGaugeColor";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x96a22aea;
pub const Sheet = excel.Typed(ContentGaugeColor);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "AndroidColor1", "AndroidColor2", "AndroidColor3" };

/// An RGB color, 0xRRGGBB.
pub fn androidColor1(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// An RGB color, 0xRRGGBB.
pub fn androidColor2(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// An RGB color, 0xRRGGBB.
pub fn androidColor3(self: @This()) u32 {
    return self.row.at(u32, 8);
}
