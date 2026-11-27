//! `FateShop`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const FateShop = @This();

pub const sheet_name = "FateShop";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x58d1a3e4;
pub const Sheet = excel.Typed(FateShop);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "SpecialShop[0]", "SpecialShop[1]", "SpecialShop[2]", "DefaultTalk[0]", "DefaultTalk[1]", "DefaultTalk[2]", "DefaultTalk[3]", "DefaultTalk[4]", "DefaultTalk[5]", "DefaultTalk[6]", "DefaultTalk[7]", "DefaultTalk[8]" };

pub const special_shop_len = 3;
/// Links to `SpecialShop`.
pub fn specialShop(self: @This(), n0: usize) excel.Link(sheets.SpecialShop) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

pub const default_talk_len = 9;
/// Links to `DefaultTalk`.
pub fn defaultTalk(self: @This(), n0: usize) excel.Link(sheets.DefaultTalk) {
    return .of(self.row.at(u32, offsets_2[n0]));
}

const offsets_1 = [3]u16{ 0, 4, 8 };
const offsets_2 = [9]u16{ 12, 16, 20, 24, 28, 32, 36, 40, 44 };
