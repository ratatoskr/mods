//! `GimmickAccessor`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GimmickAccessor = @This();

pub const sheet_name = "GimmickAccessor";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe3c066e6;
pub const Sheet = excel.Typed(GimmickAccessor);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Type", "Param0", "Param1", "Param2", "Param3", "Param4", "Param5", "Unknown6", "Unknown3", "Unknown4", "Unknown5" };

/// Links by `Type`: 2 to `GimmickYesNo`, 3 to `GimmickYesNo`, 4 to `LogMessage`, 5 to `GimmickYesNo`, 6 to `GimmickYesNo`, 7 to `LogMessage`, 10 to `GimmickYesNo`, 14 to `GimmickYesNo`, 17 to `GimmickTalk`, 22 to `GimmickYesNo`.
pub fn param0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// Links by `Type`: 3 to `LogMessage`.
pub fn param1(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// Links by `Type`: 5 to `LogMessage`.
pub fn param2(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn param3(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn param4(self: @This()) u32 {
    return self.row.at(u32, 16);
}

pub fn param5(self: @This()) u32 {
    return self.row.at(u32, 20);
}

pub fn @"type"(self: @This()) i32 {
    return self.row.at(i32, 24);
}

pub fn unknown6(self: @This()) bool {
    return self.row.bitAt(28, 0);
}

pub fn unknown3(self: @This()) bool {
    return self.row.bitAt(28, 1);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(28, 2);
}

pub fn unknown5(self: @This()) bool {
    return self.row.bitAt(28, 3);
}
