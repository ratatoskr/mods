//! `Credit`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Credit = @This();

pub const sheet_name = "Credit";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x1fe6ec22;
pub const Sheet = excel.Typed(Credit);

row: excel.Row,

/// Links to `CreditCast`.
pub fn roles1(self: @This()) excel.Link(sheets.CreditCast) {
    return .of(self.row.at(u16, 0));
}

/// Links to `CreditCast`.
pub fn japaneseCast1(self: @This()) excel.Link(sheets.CreditCast) {
    return .of(self.row.at(u16, 2));
}

/// Links to `CreditCast`.
pub fn englishCast1(self: @This()) excel.Link(sheets.CreditCast) {
    return .of(self.row.at(u16, 4));
}

/// Links to `CreditCast`.
pub fn frenchCast1(self: @This()) excel.Link(sheets.CreditCast) {
    return .of(self.row.at(u16, 6));
}

/// Links to `CreditCast`.
pub fn germanCast1(self: @This()) excel.Link(sheets.CreditCast) {
    return .of(self.row.at(u16, 8));
}

/// Links to `CreditCast`.
pub fn roles2(self: @This()) excel.Link(sheets.CreditCast) {
    return .of(self.row.at(u16, 10));
}

/// Links to `CreditCast`.
pub fn japaneseCast2(self: @This()) excel.Link(sheets.CreditCast) {
    return .of(self.row.at(u16, 12));
}

/// Links to `CreditCast`.
pub fn englishCast2(self: @This()) excel.Link(sheets.CreditCast) {
    return .of(self.row.at(u16, 14));
}

/// Links to `CreditCast`.
pub fn frenchCast2(self: @This()) excel.Link(sheets.CreditCast) {
    return .of(self.row.at(u16, 16));
}

/// Links to `CreditCast`.
pub fn germanCast2(self: @This()) excel.Link(sheets.CreditCast) {
    return .of(self.row.at(u16, 18));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 20);
}
