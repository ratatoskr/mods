//! `CharaCardHeader`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CharaCardHeader = @This();

pub const sheet_name = "CharaCardHeader";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x560f99b3;
pub const Sheet = excel.Typed(CharaCardHeader);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn topImage(self: @This()) i32 {
    return self.row.at(i32, 4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn bottomImage(self: @This()) i32 {
    return self.row.at(i32, 8);
}

/// Links to `BannerCondition`.
pub fn unlockCondition(self: @This()) excel.Link(sheets.BannerCondition) {
    return .of(self.row.at(u16, 12));
}

pub fn unknown_70_1(self: @This()) u16 {
    return self.row.at(u16, 14);
}

pub fn unknown_70_2(self: @This()) u16 {
    return self.row.at(u16, 16);
}

pub fn unknown4(self: @This()) u16 {
    return self.row.at(u16, 18);
}

pub fn unknown5(self: @This()) u16 {
    return self.row.at(u16, 20);
}

pub fn fontColor(self: @This()) u8 {
    return self.row.at(u8, 22);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 23);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 24);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 25);
}

/// Links to `CharaCardDesignCategory`.
pub fn category(self: @This()) excel.Link(sheets.CharaCardDesignCategory) {
    return .of(self.row.at(u8, 26));
}
