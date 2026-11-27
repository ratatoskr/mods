//! `RetainerTask`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const RetainerTask = @This();

pub const sheet_name = "RetainerTask";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x99415e4e;
pub const Sheet = excel.Typed(RetainerTask);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "IsRandom", "ClassJobCategory", "RetainerLevel", "Unknown0", "RetainerTaskParameter", "VentureCost", "MaxTimemin", "Experience", "RequiredItemLevel", "ConditionParam0", "ConditionParam1", "RequiredGathering", "Unknown1", "Task" };

pub fn experience(self: @This()) i32 {
    return self.row.at(i32, 0);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 4);
}

/// Links to `RetainerTaskParameter`.
pub fn retainerTaskParameter(self: @This()) excel.Link(sheets.RetainerTaskParameter) {
    return .of(self.row.at(u16, 6));
}

pub fn ventureCost(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn maxTimemin(self: @This()) u16 {
    return self.row.at(u16, 10);
}

pub fn requiredItemLevel(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn requiredGathering(self: @This()) u16 {
    return self.row.at(u16, 14);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 16);
}

/// Links to `RetainerTaskNormal` or `RetainerTaskRandom`, whichever has the row.
pub fn task(self: @This()) u16 {
    return self.row.at(u16, 18);
}

/// Links to `ClassJobCategory`.
pub fn classJobCategory(self: @This()) excel.Link(sheets.ClassJobCategory) {
    return .of(self.row.at(u8, 20));
}

pub fn retainerLevel(self: @This()) u8 {
    return self.row.at(u8, 21);
}

pub fn conditionParam0(self: @This()) u8 {
    return self.row.at(u8, 22);
}

pub fn conditionParam1(self: @This()) u8 {
    return self.row.at(u8, 23);
}

pub fn isRandom(self: @This()) bool {
    return self.row.bitAt(24, 0);
}
