//! `MotionTimelineBlendTable`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MotionTimelineBlendTable = @This();

pub const sheet_name = "MotionTimelineBlendTable";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x69213275;
pub const Sheet = excel.Typed(MotionTimelineBlendTable);

row: excel.Row,

pub fn destBlendGroup(self: @This()) u8 {
    return self.row.at(u8, 0);
}

pub fn srcBlendGroup(self: @This()) u8 {
    return self.row.at(u8, 1);
}

pub fn blendFrame_PC(self: @This()) u8 {
    return self.row.at(u8, 2);
}

pub fn blendFram_TypeA(self: @This()) u8 {
    return self.row.at(u8, 3);
}

pub fn blendFram_TypeB(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn blendFram_TypeC(self: @This()) u8 {
    return self.row.at(u8, 5);
}
