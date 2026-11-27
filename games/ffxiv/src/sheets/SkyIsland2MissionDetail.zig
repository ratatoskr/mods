//! `SkyIsland2MissionDetail`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Objective`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SkyIsland2MissionDetail = @This();

pub const sheet_name = "SkyIsland2MissionDetail";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x62246edb;
pub const Sheet = excel.Typed(SkyIsland2MissionDetail);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Type", "Unknown5", "Range", "Unknown6", "EObj", "Unknown3", "Unknown4", "Objective", "Unknown0", "Unknown1", "Unknown2" };

pub fn objective(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown1(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn unknown2(self: @This()) []const u8 {
    return self.row.stringAt(12);
}

/// Links to `EObjName`.
pub fn eObj(self: @This()) excel.Link(sheets.EObjName) {
    return .of(self.row.at(u32, 16));
}

pub fn unknown3(self: @This()) u32 {
    return self.row.at(u32, 20);
}

pub fn unknown4(self: @This()) u32 {
    return self.row.at(u32, 24);
}

/// Links to `SkyIsland2MissionType`.
pub fn @"type"(self: @This()) excel.Link(sheets.SkyIsland2MissionType) {
    return .of(self.row.at(u8, 28));
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 29);
}

/// Links to `SkyIsland2RangeType`.
pub fn range(self: @This()) excel.Link(sheets.SkyIsland2RangeType) {
    return .of(self.row.at(u8, 30));
}

pub fn unknown6(self: @This()) i8 {
    return self.row.at(i8, 31);
}
