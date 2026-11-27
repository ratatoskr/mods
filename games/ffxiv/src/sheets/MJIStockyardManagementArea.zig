//! `MJIStockyardManagementArea`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Area`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJIStockyardManagementArea = @This();

pub const sheet_name = "MJIStockyardManagementArea";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x43bdd5b1;
pub const Sheet = excel.Typed(MJIStockyardManagementArea);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "RareMaterial", "Unknown0", "Area" };

/// Links to `MJIText`.
pub fn area(self: @This()) excel.Link(sheets.MJIText) {
    return .of(self.row.at(u16, 0));
}

/// Links to `MJIItemPouch`.
pub fn rareMaterial(self: @This()) excel.Link(sheets.MJIItemPouch) {
    return .of(self.row.at(u8, 2));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 3);
}
