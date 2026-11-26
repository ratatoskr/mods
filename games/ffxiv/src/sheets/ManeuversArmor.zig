//! `ManeuversArmor`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ManeuversArmor = @This();

pub const sheet_name = "ManeuversArmor";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc8b98ed4;
pub const Sheet = excel.Typed(ManeuversArmor);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

/// Links to `BNpcName`.
pub fn falconName(self: @This()) excel.Link(sheets.BNpcName) {
    return .of(self.row.at(u32, 8));
}

/// Links to `BNpcName`.
pub fn ravenName(self: @This()) excel.Link(sheets.BNpcName) {
    return .of(self.row.at(u32, 12));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn neutralMapIcon(self: @This()) u32 {
    return self.row.at(u32, 16);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn falconImage(self: @This()) u32 {
    return self.row.at(u32, 20);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn ravenImage(self: @This()) u32 {
    return self.row.at(u32, 24);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn falconMapImage(self: @This()) u32 {
    return self.row.at(u32, 28);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn ravenMapImage(self: @This()) u32 {
    return self.row.at(u32, 32);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 36);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 38);
}

pub fn unknown2(self: @This()) bool {
    return self.row.bitAt(39, 0);
}
