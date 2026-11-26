//! `DynamicEventSingleBattle`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DynamicEventSingleBattle = @This();

pub const sheet_name = "DynamicEventSingleBattle";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe760c985;
pub const Sheet = excel.Typed(DynamicEventSingleBattle);

row: excel.Row,

pub fn text(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// Links to `BNpcName`.
pub fn bNpcName(self: @This()) excel.Link(sheets.BNpcName) {
    return .of(self.row.at(i32, 8));
}
