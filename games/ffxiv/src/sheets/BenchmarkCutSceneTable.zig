//! `BenchmarkCutSceneTable`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BenchmarkCutSceneTable = @This();

pub const sheet_name = "BenchmarkCutSceneTable";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x87bff331;
pub const Sheet = excel.Typed(BenchmarkCutSceneTable);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Unknown3", "Unknown1", "Unknown2", "Unknown4", "Unknown6", "Unknown5" };

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) f32 {
    return self.row.at(f32, 4);
}

pub fn unknown2(self: @This()) f32 {
    return self.row.at(f32, 8);
}

pub fn unknown3(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn unknown4(self: @This()) u32 {
    return self.row.at(u32, 16);
}

pub fn unknown5(self: @This()) u32 {
    return self.row.at(u32, 20);
}

pub fn unknown6(self: @This()) bool {
    return self.row.bitAt(24, 0);
}
