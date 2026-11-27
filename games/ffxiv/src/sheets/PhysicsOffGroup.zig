//! `PhysicsOffGroup`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PhysicsOffGroup = @This();

pub const sheet_name = "PhysicsOffGroup";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdb6ee4cd;
pub const Sheet = excel.Typed(PhysicsOffGroup);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Unknown1", "Unknown_70_1", "Unknown_70_2", "Unknown_70_3", "Unknown_70_4", "Unknown_70_5", "Unknown_70_6", "Unknown_70_7", "Unknown_70_8", "Unknown_70_9", "Unknown_70_10", "Unknown_70_11", "Unknown_70_12", "Unknown_70_13", "Unknown_70_14" };

pub fn unknown0(self: @This()) i8 {
    return self.row.at(i8, 0);
}

pub fn unknown1(self: @This()) i8 {
    return self.row.at(i8, 1);
}

pub fn unknown_70_1(self: @This()) i8 {
    return self.row.at(i8, 2);
}

pub fn unknown_70_2(self: @This()) i8 {
    return self.row.at(i8, 3);
}

pub fn unknown_70_3(self: @This()) i8 {
    return self.row.at(i8, 4);
}

pub fn unknown_70_4(self: @This()) i8 {
    return self.row.at(i8, 5);
}

pub fn unknown_70_5(self: @This()) i8 {
    return self.row.at(i8, 6);
}

pub fn unknown_70_6(self: @This()) i8 {
    return self.row.at(i8, 7);
}

pub fn unknown_70_7(self: @This()) i8 {
    return self.row.at(i8, 8);
}

pub fn unknown_70_8(self: @This()) i8 {
    return self.row.at(i8, 9);
}

pub fn unknown_70_9(self: @This()) i8 {
    return self.row.at(i8, 10);
}

pub fn unknown_70_10(self: @This()) i8 {
    return self.row.at(i8, 11);
}

pub fn unknown_70_11(self: @This()) i8 {
    return self.row.at(i8, 12);
}

pub fn unknown_70_12(self: @This()) i8 {
    return self.row.at(i8, 13);
}

pub fn unknown_70_13(self: @This()) i8 {
    return self.row.at(i8, 14);
}

pub fn unknown_70_14(self: @This()) i8 {
    return self.row.at(i8, 15);
}
