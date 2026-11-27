//! `AOZArrangement`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AOZArrangement = @This();

pub const sheet_name = "AOZArrangement";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x2020acf6;
pub const Sheet = excel.Typed(AOZArrangement);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "AOZContentBriefingBNpc", "Position" };

/// Links to `AOZContentBriefingBNpc`.
pub fn aozContentBriefingBNpc(self: @This()) excel.Link(sheets.AOZContentBriefingBNpc) {
    return .of(self.row.at(u16, 0));
}

pub fn position(self: @This()) u16 {
    return self.row.at(u16, 2);
}
