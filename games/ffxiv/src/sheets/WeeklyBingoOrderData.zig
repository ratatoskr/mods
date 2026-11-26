//! `WeeklyBingoOrderData`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WeeklyBingoOrderData = @This();

pub const sheet_name = "WeeklyBingoOrderData";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x13bf765e;
pub const Sheet = excel.Typed(WeeklyBingoOrderData);

row: excel.Row,

pub fn @"type"(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// Links by `Type`: 0 to `InstanceContent`, 4 to `WeeklyBingoMultipleOrder`.
pub fn data(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unknown2(self: @This()) u32 {
    return self.row.at(u32, 8);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 16);
}

/// Links to `WeeklyBingoText`.
pub fn text(self: @This()) excel.Link(sheets.WeeklyBingoText) {
    return .of(self.row.at(u8, 17));
}

/// 1= TreasureMaps
/// 2= PvP
pub fn contentCategory(self: @This()) u8 {
    return self.row.at(u8, 18);
}
