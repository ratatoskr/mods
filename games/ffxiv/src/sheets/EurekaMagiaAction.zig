//! `EurekaMagiaAction`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EurekaMagiaAction = @This();

pub const sheet_name = "EurekaMagiaAction";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5a516458;
pub const Sheet = excel.Typed(EurekaMagiaAction);

row: excel.Row,

/// Links to `Action`.
pub fn action(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(u32, 0));
}

pub fn maxUses(self: @This()) u8 {
    return self.row.at(u8, 4);
}
