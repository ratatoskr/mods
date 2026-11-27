//! `Eureka`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Eureka = @This();

pub const sheet_name = "Eureka";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x8f1df131;
pub const Sheet = excel.Typed(Eureka);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown2", "Unknown3", "Unknown0", "Unknown1", "Unknown4" };

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 2);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 5);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(6, 0);
}
