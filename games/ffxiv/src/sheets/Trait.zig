//! `Trait`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Trait = @This();

pub const sheet_name = "Trait";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe8360975;
pub const Sheet = excel.Typed(Trait);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `Quest`.
pub fn quest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 4));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 8);
}

pub fn value(self: @This()) i16 {
    return self.row.at(i16, 12);
}

/// Links to `ClassJob`.
pub fn classJob(self: @This()) excel.Link(sheets.ClassJob) {
    return .of(self.row.at(u8, 14));
}

/// Links to `ClassJobCategory`.
pub fn classJobCategory(self: @This()) excel.Link(sheets.ClassJobCategory) {
    return .of(self.row.at(u8, 15));
}

pub fn level(self: @This()) u8 {
    return self.row.at(u8, 16);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 17);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 18);
}

pub fn unknown1(self: @This()) bool {
    return self.row.bitAt(19, 0);
}
