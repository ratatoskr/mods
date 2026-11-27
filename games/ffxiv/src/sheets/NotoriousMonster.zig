//! `NotoriousMonster`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `BNpcName`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const NotoriousMonster = @This();

pub const sheet_name = "NotoriousMonster";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x307c9206;
pub const Sheet = excel.Typed(NotoriousMonster);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "BNpcBase", "Rank", "BNpcName", "Unknown0" };

/// Links to `BNpcName`.
pub fn bNpcName(self: @This()) excel.Link(sheets.BNpcName) {
    return .of(self.row.at(u32, 0));
}

/// Links to `BNpcBase`.
pub fn bNpcBase(self: @This()) excel.Link(sheets.BNpcBase) {
    return .of(self.row.at(i32, 4));
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn rank(self: @This()) u8 {
    return self.row.at(u8, 10);
}
