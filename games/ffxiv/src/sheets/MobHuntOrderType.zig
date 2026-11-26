//! `MobHuntOrderType`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MobHuntOrderType = @This();

pub const sheet_name = "MobHuntOrderType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x795a75a0;
pub const Sheet = excel.Typed(MobHuntOrderType);

row: excel.Row,

/// Links to `Quest`.
pub fn quest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 0));
}

/// Links to `EventItem`.
pub fn eventItem(self: @This()) excel.Link(sheets.EventItem) {
    return .of(self.row.at(u32, 4));
}

/// Links to `MobHuntOrder`.
pub fn orderStart(self: @This()) excel.Link(sheets.MobHuntOrder) {
    return .of(self.row.at(u16, 8));
}

pub fn @"type"(self: @This()) u8 {
    return self.row.at(u8, 10);
}

pub fn orderAmount(self: @This()) u8 {
    return self.row.at(u8, 11);
}
