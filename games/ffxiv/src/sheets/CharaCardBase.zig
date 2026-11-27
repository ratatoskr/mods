//! `CharaCardBase`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CharaCardBase = @This();

pub const sheet_name = "CharaCardBase";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc9fe5b18;
pub const Sheet = excel.Typed(CharaCardBase);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Image", "FontColor", "Unknown1", "Unknown2", "Unknown3", "UnlockCondition", "Unknown_70_1", "Unknown_70_2", "Unknown4", "Category", "SortKey", "Name" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn image(self: @This()) i32 {
    return self.row.at(i32, 4);
}

/// Links to `BannerCondition`.
pub fn unlockCondition(self: @This()) excel.Link(sheets.BannerCondition) {
    return .of(self.row.at(u16, 8));
}

pub fn unknown_70_1(self: @This()) u16 {
    return self.row.at(u16, 10);
}

pub fn unknown_70_2(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn unknown4(self: @This()) u16 {
    return self.row.at(u16, 14);
}

pub fn sortKey(self: @This()) u16 {
    return self.row.at(u16, 16);
}

pub fn fontColor(self: @This()) u8 {
    return self.row.at(u8, 18);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 19);
}

/// Links to `CharaCardDesignCategory`.
pub fn category(self: @This()) excel.Link(sheets.CharaCardDesignCategory) {
    return .of(self.row.at(u8, 20));
}

pub fn unknown1(self: @This()) bool {
    return self.row.at(u8, 21) != 0;
}

pub fn unknown2(self: @This()) bool {
    return self.row.at(u8, 22) != 0;
}
