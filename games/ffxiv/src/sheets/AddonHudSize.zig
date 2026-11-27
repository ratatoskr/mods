//! `AddonHudSize`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AddonHudSize = @This();

pub const sheet_name = "AddonHudSize";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x20bf3d37;
pub const Sheet = excel.Typed(AddonHudSize);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "OffsetX", "OffsetY", "Width", "Height" };

pub fn width(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn height(self: @This()) u16 {
    return self.row.at(u16, 2);
}

pub fn offsetX(self: @This()) i16 {
    return self.row.at(i16, 4);
}

pub fn offsetY(self: @This()) i16 {
    return self.row.at(i16, 6);
}
