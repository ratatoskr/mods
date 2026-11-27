//! `ChocoboRaceRank`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ChocoboRaceRank = @This();

pub const sheet_name = "ChocoboRaceRank";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf840eabf;
pub const Sheet = excel.Typed(ChocoboRaceRank);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "RatingMin", "RatingMax", "Name", "Fee", "Icon" };

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 0);
}

pub fn ratingMin(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn ratingMax(self: @This()) u16 {
    return self.row.at(u16, 6);
}

/// Links to `GoldSaucerTextData`.
pub fn name(self: @This()) excel.Link(sheets.GoldSaucerTextData) {
    return .of(self.row.at(u16, 8));
}

pub fn fee(self: @This()) u16 {
    return self.row.at(u16, 10);
}
