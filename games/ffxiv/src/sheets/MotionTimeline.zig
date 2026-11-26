//! `MotionTimeline`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Filename`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MotionTimeline = @This();

pub const sheet_name = "MotionTimeline";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x12260494;
pub const Sheet = excel.Typed(MotionTimeline);

row: excel.Row,

pub fn filename(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn blendGroup(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn unknown_70_1(self: @This()) u8 {
    return self.row.at(u8, 5);
}

pub fn unknown_70_2(self: @This()) u8 {
    return self.row.at(u8, 6);
}

pub fn isLoop(self: @This()) bool {
    return self.row.bitAt(7, 0);
}

pub fn isBlinkEnable(self: @This()) bool {
    return self.row.bitAt(7, 1);
}

pub fn isLipEnable(self: @This()) bool {
    return self.row.bitAt(7, 2);
}

pub fn unknown0(self: @This()) bool {
    return self.row.bitAt(7, 3);
}
