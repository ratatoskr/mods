//! `EmjCharaViewCamera`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EmjCharaViewCamera = @This();

pub const sheet_name = "EmjCharaViewCamera";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x3bc4120f;
pub const Sheet = excel.Typed(EmjCharaViewCamera);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Unknown1", "Unknown2", "Unknown3", "Unknown4", "Unknown5" };

pub fn unknown0(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn unknown1(self: @This()) f32 {
    return self.row.at(f32, 4);
}

pub fn unknown2(self: @This()) f32 {
    return self.row.at(f32, 8);
}

pub fn unknown3(self: @This()) f32 {
    return self.row.at(f32, 12);
}

pub fn unknown4(self: @This()) f32 {
    return self.row.at(f32, 16);
}

pub fn unknown5(self: @This()) f32 {
    return self.row.at(f32, 20);
}
