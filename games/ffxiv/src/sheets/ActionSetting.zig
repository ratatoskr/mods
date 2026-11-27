//! `ActionSetting`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ActionSetting = @This();

pub const sheet_name = "ActionSetting";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xb42d3edf;
pub const Sheet = excel.Typed(ActionSetting);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Unknown1", "Unknown3", "Unknown4", "Unknown5", "Unknown6", "Unknown2" };

pub fn unknown0(self: @This()) i32 {
    return self.row.at(i32, 0);
}

pub fn unknown1(self: @This()) i32 {
    return self.row.at(i32, 4);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn unknown3(self: @This()) bool {
    return self.row.bitAt(9, 0);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(9, 1);
}

pub fn unknown5(self: @This()) bool {
    return self.row.bitAt(9, 2);
}

pub fn unknown6(self: @This()) bool {
    return self.row.bitAt(9, 3);
}
