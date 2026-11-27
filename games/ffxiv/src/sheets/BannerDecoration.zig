//! `BannerDecoration`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BannerDecoration = @This();

pub const sheet_name = "BannerDecoration";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xeab3567d;
pub const Sheet = excel.Typed(BannerDecoration);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Image", "Icon", "Category", "UnlockCondition", "Unknown_70_1", "Unknown_70_2", "Unknown0", "SortKey", "Name" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn image(self: @This()) i32 {
    return self.row.at(i32, 4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
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

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 18);
}

pub fn sortKey(self: @This()) u16 {
    return self.row.at(u16, 20);
}

/// Links to `CharaCardDesignCategory`.
pub fn category(self: @This()) excel.Link(sheets.CharaCardDesignCategory) {
    return .of(self.row.at(u8, 22));
}
