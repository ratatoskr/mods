//! `ItemStainCondition`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `UnlockQuest`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ItemStainCondition = @This();

pub const sheet_name = "ItemStainCondition";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdbf43666;
pub const Sheet = excel.Typed(ItemStainCondition);

row: excel.Row,

/// Links to `Quest`.
pub fn unlockQuest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 0));
}
