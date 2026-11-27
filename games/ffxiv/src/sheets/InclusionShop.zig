//! `InclusionShop`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `InclusionShopWelcom`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const InclusionShop = @This();

pub const sheet_name = "InclusionShop";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x415e17e0;
pub const Sheet = excel.Typed(InclusionShop);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "UnlockQuest", "InclusionShopWelcom", "ShopName", "Category[0]", "Category[1]", "Category[2]", "Category[3]", "Category[4]", "Category[5]", "Category[6]", "Category[7]", "Category[8]", "Category[9]", "Category[10]", "Category[11]", "Category[12]", "Category[13]", "Category[14]", "Category[15]", "Category[16]", "Category[17]", "Category[18]", "Category[19]", "Category[20]", "Category[21]", "Category[22]", "Category[23]", "Category[24]", "Category[25]", "Category[26]", "Category[27]", "Category[28]", "Category[29]" };

pub fn shopName(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub const category_len = 30;
/// Links to `InclusionShopCategory`.
pub fn category(self: @This(), n0: usize) excel.Link(sheets.InclusionShopCategory) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

/// Links to `Quest`.
pub fn unlockQuest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 64));
}

/// Links to `InclusionShopWelcom`.
pub fn inclusionShopWelcom(self: @This()) excel.Link(sheets.InclusionShopWelcom) {
    return .of(self.row.at(u8, 68));
}

const offsets_1 = [30]u16{ 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62 };
