//! `XBMBattleDetailAction`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const XBMBattleDetailAction = @This();

pub const sheet_name = "XBMBattleDetailAction";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x94a5d5d9;
pub const Sheet = excel.Typed(XBMBattleDetailAction);

row: excel.Row,

/// Links to `Action`.
pub fn action(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(u32, 0));
}

/// Links to `Status`.
pub fn status(self: @This()) excel.Link(sheets.Status) {
    return .of(self.row.at(u32, 4));
}

/// Links to `XBMActionTarget`.
pub fn actionTarget(self: @This()) excel.Link(sheets.XBMActionTarget) {
    return .of(self.row.at(u8, 8));
}

/// Links to `XBMActionEffectType`.
pub fn actionEffectType(self: @This()) excel.Link(sheets.XBMActionEffectType) {
    return .of(self.row.at(u8, 9));
}
