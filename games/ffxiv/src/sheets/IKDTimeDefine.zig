//! `IKDTimeDefine`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const IKDTimeDefine = @This();

pub const sheet_name = "IKDTimeDefine";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdcfd9eba;
pub const Sheet = excel.Typed(IKDTimeDefine);

row: excel.Row,

pub fn timeOfDay(self: @This()) u8 {
    return self.row.at(u8, 0);
}
