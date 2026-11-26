//! `AOZBoss`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Boss`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AOZBoss = @This();

pub const sheet_name = "AOZBoss";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x2020acf6;
pub const Sheet = excel.Typed(AOZBoss);

row: excel.Row,

/// Links to `AOZContentBriefingBNpc`.
pub fn boss(self: @This()) excel.Link(sheets.AOZContentBriefingBNpc) {
    return .of(self.row.at(u16, 0));
}

pub fn position(self: @This()) u16 {
    return self.row.at(u16, 2);
}
