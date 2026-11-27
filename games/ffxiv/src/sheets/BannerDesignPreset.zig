//! `BannerDesignPreset`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BannerDesignPreset = @This();

pub const sheet_name = "BannerDesignPreset";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xfccd960d;
pub const Sheet = excel.Typed(BannerDesignPreset);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Background", "Frame", "Decoration", "SortKey", "Name" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `BannerBg`.
pub fn background(self: @This()) excel.Link(sheets.BannerBg) {
    return .of(self.row.at(u16, 4));
}

/// Links to `BannerFrame`.
pub fn frame(self: @This()) excel.Link(sheets.BannerFrame) {
    return .of(self.row.at(u16, 6));
}

/// Links to `BannerDecoration`.
pub fn decoration(self: @This()) excel.Link(sheets.BannerDecoration) {
    return .of(self.row.at(u16, 8));
}

pub fn sortKey(self: @This()) u16 {
    return self.row.at(u16, 10);
}
