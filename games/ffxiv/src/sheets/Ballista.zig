//! `Ballista`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Ballista = @This();

pub const sheet_name = "Ballista";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xcac0c160;
pub const Sheet = excel.Typed(Ballista);

row: excel.Row,

/// Links to `BNpcBase`.
pub fn bnpc(self: @This()) excel.Link(sheets.BNpcBase) {
    return .of(self.row.at(u16, 0));
}

pub fn angle(self: @This()) u16 {
    return self.row.at(u16, 2);
}

/// Links to `Action`.
pub fn action0(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(u16, 4));
}

/// Links to `Action`.
pub fn action1(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(u16, 6));
}

/// Links to `Action`.
pub fn action2(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(u16, 8));
}

/// Links to `Action`.
pub fn action3(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(u16, 10));
}

pub fn bullet(self: @This()) u8 {
    return self.row.at(u8, 12);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 13);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 14);
}

pub fn near(self: @This()) i8 {
    return self.row.at(i8, 15);
}

pub fn far(self: @This()) i8 {
    return self.row.at(i8, 16);
}
