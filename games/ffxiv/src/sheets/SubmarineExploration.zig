//! `SubmarineExploration`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Destination`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SubmarineExploration = @This();

pub const sheet_name = "SubmarineExploration";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xff922bb4;
pub const Sheet = excel.Typed(SubmarineExploration);

row: excel.Row,

pub fn destination(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn location(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn expReward(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn surveyDurationmin(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn x(self: @This()) i16 {
    return self.row.at(i16, 14);
}

pub fn y(self: @This()) i16 {
    return self.row.at(i16, 16);
}

pub fn z(self: @This()) i16 {
    return self.row.at(i16, 18);
}

/// Links to `SubmarineMap`.
pub fn map(self: @This()) excel.Link(sheets.SubmarineMap) {
    return .of(self.row.at(u8, 20));
}

pub fn stars(self: @This()) u8 {
    return self.row.at(u8, 21);
}

pub fn rankReq(self: @This()) u8 {
    return self.row.at(u8, 22);
}

pub fn ceruleumTankReq(self: @This()) u8 {
    return self.row.at(u8, 23);
}

pub fn surveyDistance(self: @This()) u8 {
    return self.row.at(u8, 24);
}

pub fn startingPoint(self: @This()) bool {
    return self.row.bitAt(25, 0);
}
