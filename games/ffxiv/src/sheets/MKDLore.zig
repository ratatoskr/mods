//! `MKDLore`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MKDLore = @This();

pub const sheet_name = "MKDLore";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x3d2f1c04;
pub const Sheet = excel.Typed(MKDLore);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unlockLink(self: @This()) u32 {
    return self.row.at(u32, 8);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn image(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn unknown4(self: @This()) u32 {
    return self.row.at(u32, 16);
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 20);
}

pub fn unknown6(self: @This()) u8 {
    return self.row.at(u8, 21);
}
