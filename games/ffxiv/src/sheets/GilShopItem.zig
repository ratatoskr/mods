//! `GilShopItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GilShopItem = @This();

pub const sheet_name = "GilShopItem";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xb375f1d2;
pub const Sheet = excel.Typed(GilShopItem);

row: excel.Row,

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 0));
}

pub const quest_required_len = 2;
/// Links to `Quest`.
pub fn questRequired(self: @This(), n0: usize) excel.Link(sheets.Quest) {
    return .of(self.row.at(i32, offsets_1[n0]));
}

/// Links to `Achievement`.
pub fn achievementRequired(self: @This()) excel.Link(sheets.Achievement) {
    return .of(self.row.at(i32, 12));
}

pub fn stateRequired(self: @This()) u16 {
    return self.row.at(u16, 16);
}

pub fn patch(self: @This()) u16 {
    return self.row.at(u16, 18);
}

pub fn unknown_70_1(self: @This()) u8 {
    return self.row.at(u8, 20);
}

pub fn unknown_70_2(self: @This()) u8 {
    return self.row.at(u8, 21);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 22);
}

pub fn isHQ(self: @This()) bool {
    return self.row.bitAt(23, 0);
}

const offsets_1 = [2]u16{ 4, 8 };
