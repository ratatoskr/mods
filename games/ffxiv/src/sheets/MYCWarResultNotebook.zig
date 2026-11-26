//! `MYCWarResultNotebook`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MYCWarResultNotebook = @This();

pub const sheet_name = "MYCWarResultNotebook";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x02f3734a;
pub const Sheet = excel.Typed(MYCWarResultNotebook);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn nameJP(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

/// Links to `Quest`.
pub fn quest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(i32, 12));
}

pub fn unknown0(self: @This()) i32 {
    return self.row.at(i32, 16);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 20);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn image(self: @This()) i32 {
    return self.row.at(i32, 24);
}

pub fn number(self: @This()) u8 {
    return self.row.at(u8, 28);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 29);
}

pub fn link(self: @This()) u8 {
    return self.row.at(u8, 30);
}

pub fn rarity(self: @This()) u8 {
    return self.row.at(u8, 31);
}
