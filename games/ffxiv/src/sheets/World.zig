//! `World`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const World = @This();

pub const sheet_name = "World";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf59cc6af;
pub const Sheet = excel.Typed(World);

row: excel.Row,

pub fn internalName(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

/// Links to `WorldDCGroupType`.
pub fn dataCenter(self: @This()) excel.Link(sheets.WorldDCGroupType) {
    return .of(self.row.at(u8, 8));
}

/// Links to `WorldDCGroupType`.
pub fn logicalDataCenter(self: @This()) excel.Link(sheets.WorldDCGroupType) {
    return .of(self.row.at(u8, 9));
}

pub fn userType(self: @This()) u8 {
    return self.row.at(u8, 10);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 11);
}

/// 0 = N/A
/// 1 = Global
/// 2 = China
/// 3 = Korea
pub fn region(self: @This()) u8 {
    return self.row.at(u8, 12);
}

/// For cross-world duties only
pub fn isContent(self: @This()) bool {
    return self.row.bitAt(13, 0);
}

pub fn isPublic(self: @This()) bool {
    return self.row.bitAt(13, 1);
}
