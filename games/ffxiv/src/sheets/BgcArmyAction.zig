//! `BgcArmyAction`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BgcArmyAction = @This();

pub const sheet_name = "BgcArmyAction";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x62947e52;
pub const Sheet = excel.Typed(BgcArmyAction);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown2", "Name", "Icon", "Unknown3", "Unknown4" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 4);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 10);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(11, 0);
}
