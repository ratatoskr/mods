//! `UDS_Event`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Text`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const UDS_Event = @This();

pub const sheet_name = "UDS_Event";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdfabf9e4;
pub const Sheet = excel.Typed(UDS_Event);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Text", "Type", "Property[0]", "Property[1]", "Property[2]", "Property[3]", "Property[4]", "Property[5]", "Property[6]", "Property[7]", "Property[8]", "Property[9]", "Property[10]", "Property[11]", "Property[12]", "Property[13]", "Property[14]", "Property[15]", "Property[16]", "Property[17]", "Property[18]", "Property[19]", "Property[20]", "Property[21]", "Property[22]", "Property[23]", "Property[24]", "Property[25]", "Property[26]", "Property[27]", "Property[28]", "Property[29]", "Property[30]", "Property[31]" };

pub fn text(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn @"type"(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub const property_len = 32;
/// Links to `UDS_Property`.
pub fn property(self: @This(), n0: usize) excel.Link(sheets.UDS_Property) {
    return .of(self.row.at(i32, offsets_1[n0]));
}

const offsets_1 = [32]u16{ 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 68, 72, 76, 80, 84, 88, 92, 96, 100, 104, 108, 112, 116, 120, 124, 128, 132 };
