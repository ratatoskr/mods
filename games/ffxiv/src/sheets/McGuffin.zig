//! `McGuffin`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const McGuffin = @This();

pub const sheet_name = "McGuffin";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdcfd9eba;
pub const Sheet = excel.Typed(McGuffin);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{"UIData"};

/// Links to `McGuffinUIData`.
pub fn uiData(self: @This()) excel.Link(sheets.McGuffinUIData) {
    return .of(self.row.at(u8, 0));
}
