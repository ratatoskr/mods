//! `BNpcState`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BNpcState = @This();

pub const sheet_name = "BNpcState";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x439de63e;
pub const Sheet = excel.Typed(BNpcState);

row: excel.Row,

pub fn scale(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn loopTimeline(self: @This()) i32 {
    return self.row.at(i32, 4);
}

pub fn idle(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn slot(self: @This()) u8 {
    return self.row.at(u8, 10);
}

pub fn modelState(self: @This()) u8 {
    return self.row.at(u8, 11);
}

pub fn attribute0(self: @This()) u8 {
    return self.row.at(u8, 12);
}

pub fn attribute1(self: @This()) u8 {
    return self.row.at(u8, 13);
}

pub fn attribute2(self: @This()) u8 {
    return self.row.at(u8, 14);
}

/// Links to `ModelScale`.
pub fn modelScale(self: @This()) excel.Link(sheets.ModelScale) {
    return .of(self.row.at(u8, 15));
}

pub const animation_states_len = 2;
pub fn animationStates(self: @This(), n0: usize) i8 {
    return self.row.at(i8, offsets_1[n0]);
}

pub fn attributeFlag0(self: @This()) bool {
    return self.row.at(u8, 18) != 0;
}

pub fn attributeFlag1(self: @This()) bool {
    return self.row.at(u8, 19) != 0;
}

pub fn attributeFlag2(self: @This()) bool {
    return self.row.at(u8, 20) != 0;
}

pub fn unknown3(self: @This()) bool {
    return self.row.bitAt(21, 0);
}

const offsets_1 = [2]u16{ 16, 17 };
