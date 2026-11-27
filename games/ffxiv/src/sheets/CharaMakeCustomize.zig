//! `CharaMakeCustomize`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Icon`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CharaMakeCustomize = @This();

pub const sheet_name = "CharaMakeCustomize";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc30e9b73;
pub const Sheet = excel.Typed(CharaMakeCustomize);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "FeatureID", "Icon", "UnlockLink", "IsPurchasable", "Hint", "HintItem", "Unknown0" };

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// Links to `Lobby`.
pub fn hint(self: @This()) excel.Link(sheets.Lobby) {
    return .of(self.row.at(u32, 4));
}

/// Links to `Item`.
pub fn hintItem(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 8));
}

pub fn unlockLink(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn featureID(self: @This()) u8 {
    return self.row.at(u8, 14);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 15);
}

pub fn isPurchasable(self: @This()) bool {
    return self.row.bitAt(16, 0);
}
