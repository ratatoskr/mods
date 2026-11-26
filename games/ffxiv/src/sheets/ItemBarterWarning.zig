//! `ItemBarterWarning`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ItemBarterWarning = @This();

pub const sheet_name = "ItemBarterWarning";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdbf43666;
pub const Sheet = excel.Typed(ItemBarterWarning);

row: excel.Row,

/// Links to `Achievement`.
pub fn achievement(self: @This()) excel.Link(sheets.Achievement) {
    return .of(self.row.at(u32, 0));
}
