//! `WKSAetheryteObjectGroup`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSAetheryteObjectGroup = @This();

pub const sheet_name = "WKSAetheryteObjectGroup";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x70a6085c;
pub const Sheet = excel.Typed(WKSAetheryteObjectGroup);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown1", "Unknown2", "Unknown0" };

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 6);
}
