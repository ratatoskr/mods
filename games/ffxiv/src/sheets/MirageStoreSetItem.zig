//! `MirageStoreSetItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MirageStoreSetItem = @This();

pub const sheet_name = "MirageStoreSetItem";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5196d053;
pub const Sheet = excel.Typed(MirageStoreSetItem);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "MainHand", "OffHand", "Head", "Body", "Hands", "Legs", "Feet", "Earrings", "Necklace", "Bracelets", "Ring" };

/// Links to `Item`.
pub fn mainHand(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 0));
}

/// Links to `Item`.
pub fn offHand(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 4));
}

/// Links to `Item`.
pub fn head(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 8));
}

/// Links to `Item`.
pub fn body(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 12));
}

/// Links to `Item`.
pub fn hands(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 16));
}

/// Links to `Item`.
pub fn legs(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 20));
}

/// Links to `Item`.
pub fn feet(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 24));
}

/// Links to `Item`.
pub fn earrings(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 28));
}

/// Links to `Item`.
pub fn necklace(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 32));
}

/// Links to `Item`.
pub fn bracelets(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 36));
}

/// Links to `Item`.
pub fn ring(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 40));
}
