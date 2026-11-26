//! `ItemBarterCheck`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ItemBarterCheck = @This();

pub const sheet_name = "ItemBarterCheck";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x8920dbd8;
pub const Sheet = excel.Typed(ItemBarterCheck);

row: excel.Row,

/// Links to `LogMessage` or `Addon`, whichever has the row.
pub fn question(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// Links to `Addon`.
pub fn confirm(self: @This()) excel.Link(sheets.Addon) {
    return .of(self.row.at(u32, 4));
}

/// Links to `AddonTransient`.
pub fn category(self: @This()) excel.Link(sheets.AddonTransient) {
    return .of(self.row.at(u16, 8));
}
