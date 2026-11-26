//! `DeliveryQuest`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Quest`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DeliveryQuest = @This();

pub const sheet_name = "DeliveryQuest";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xda365c51;
pub const Sheet = excel.Typed(DeliveryQuest);

row: excel.Row,

/// Links to `Quest`.
pub fn quest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(i32, 0));
}
