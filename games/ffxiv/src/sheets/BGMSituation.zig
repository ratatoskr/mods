//! `BGMSituation`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BGMSituation = @This();

pub const sheet_name = "BGMSituation";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x64a88f98;
pub const Sheet = excel.Typed(BGMSituation);

row: excel.Row,

/// Links to `BGM`.
pub fn daytimeID(self: @This()) excel.Link(sheets.BGM) {
    return .of(self.row.at(u16, 0));
}

/// Links to `BGM`.
pub fn nightID(self: @This()) excel.Link(sheets.BGM) {
    return .of(self.row.at(u16, 2));
}

/// Links to `BGM`.
pub fn battleID(self: @This()) excel.Link(sheets.BGM) {
    return .of(self.row.at(u16, 4));
}

/// Links to `BGM`.
pub fn daybreakID(self: @This()) excel.Link(sheets.BGM) {
    return .of(self.row.at(u16, 6));
}

/// Links to `BGM`.
pub fn twilightID(self: @This()) excel.Link(sheets.BGM) {
    return .of(self.row.at(u16, 8));
}
