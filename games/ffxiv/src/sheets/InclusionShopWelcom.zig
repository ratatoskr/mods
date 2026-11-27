//! `InclusionShopWelcom`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `ShopName`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const InclusionShopWelcom = @This();

pub const sheet_name = "InclusionShopWelcom";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xfd08b3c9;
pub const Sheet = excel.Typed(InclusionShopWelcom);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "ShopName", "WelcomeText" };

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 0);
}

/// Links to `InclusionShopWelcomText`.
pub fn shopName(self: @This()) excel.Link(sheets.InclusionShopWelcomText) {
    return .of(self.row.at(u8, 1));
}

/// Links to `InclusionShopWelcomText`.
pub fn welcomeText(self: @This()) excel.Link(sheets.InclusionShopWelcomText) {
    return .of(self.row.at(u8, 2));
}
