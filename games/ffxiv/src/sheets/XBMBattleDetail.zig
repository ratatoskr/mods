//! `XBMBattleDetail`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const XBMBattleDetail = @This();

pub const sheet_name = "XBMBattleDetail";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xe4efcb60;
pub const Sheet = excel.Typed(XBMBattleDetail);

row: excel.Row,

/// Links to `BNpcName`.
pub fn name(self: @This()) excel.Link(sheets.BNpcName) {
    return .of(self.row.at(u32, 0));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// Links to `XBMBattleDetailAction`.
pub fn action1(self: @This()) excel.Link(sheets.XBMBattleDetailAction) {
    return .of(self.row.at(u16, 8));
}

/// Links to `XBMBattleDetailAction`.
pub fn action2(self: @This()) excel.Link(sheets.XBMBattleDetailAction) {
    return .of(self.row.at(u16, 10));
}

/// Links to `BNpcResist`.
pub fn resist(self: @This()) excel.Link(sheets.BNpcResist) {
    return .of(self.row.at(u16, 12));
}

pub fn strength(self: @This()) u8 {
    return self.row.at(u8, 14);
}

pub fn intelligence(self: @This()) u8 {
    return self.row.at(u8, 15);
}

pub fn physResistance(self: @This()) u8 {
    return self.row.at(u8, 16);
}

pub fn magResistance(self: @This()) u8 {
    return self.row.at(u8, 17);
}

pub fn constitution(self: @This()) u8 {
    return self.row.at(u8, 18);
}

/// Links to `XBMElement`.
pub fn weakness(self: @This()) excel.Link(sheets.XBMElement) {
    return .of(self.row.at(u8, 19));
}
