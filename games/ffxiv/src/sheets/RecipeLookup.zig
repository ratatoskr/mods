//! `RecipeLookup`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const RecipeLookup = @This();

pub const sheet_name = "RecipeLookup";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xa708a4a0;
pub const Sheet = excel.Typed(RecipeLookup);

row: excel.Row,

/// Links to `Recipe`.
pub fn crp(self: @This()) excel.Link(sheets.Recipe) {
    return .of(self.row.at(u16, 0));
}

/// Links to `Recipe`.
pub fn bsm(self: @This()) excel.Link(sheets.Recipe) {
    return .of(self.row.at(u16, 2));
}

/// Links to `Recipe`.
pub fn arm(self: @This()) excel.Link(sheets.Recipe) {
    return .of(self.row.at(u16, 4));
}

/// Links to `Recipe`.
pub fn gsm(self: @This()) excel.Link(sheets.Recipe) {
    return .of(self.row.at(u16, 6));
}

/// Links to `Recipe`.
pub fn ltw(self: @This()) excel.Link(sheets.Recipe) {
    return .of(self.row.at(u16, 8));
}

/// Links to `Recipe`.
pub fn wvr(self: @This()) excel.Link(sheets.Recipe) {
    return .of(self.row.at(u16, 10));
}

/// Links to `Recipe`.
pub fn alc(self: @This()) excel.Link(sheets.Recipe) {
    return .of(self.row.at(u16, 12));
}

/// Links to `Recipe`.
pub fn cul(self: @This()) excel.Link(sheets.Recipe) {
    return .of(self.row.at(u16, 14));
}
