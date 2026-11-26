//! `XBMContentBattle`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const XBMContentBattle = @This();

pub const sheet_name = "XBMContentBattle";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xd870e208;
pub const Sheet = excel.Typed(XBMContentBattle);

row: excel.Row,

/// Links to `XBMBattleDetail`.
pub fn battleDetail(self: @This()) excel.Link(sheets.XBMBattleDetail) {
    return .of(self.row.at(u16, 0));
}
