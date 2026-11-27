//! `AirshipExplorationPoint`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AirshipExplorationPoint = @This();

pub const sheet_name = "AirshipExplorationPoint";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x307f38a2;
pub const Sheet = excel.Typed(AirshipExplorationPoint);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "NameShort", "Passengers", "X", "Y", "RankReq", "CeruleumTankReq", "SurveyDurationmin", "SurveyDistance", "Unknown0", "SurveillanceReq", "Unknown1", "Unknown2", "ExpReward" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn nameShort(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn expReward(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn ceruleumTankReq(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn surveyDurationmin(self: @This()) u16 {
    return self.row.at(u16, 14);
}

pub fn surveyDistance(self: @This()) u16 {
    return self.row.at(u16, 16);
}

pub fn x(self: @This()) i16 {
    return self.row.at(i16, 18);
}

pub fn y(self: @This()) i16 {
    return self.row.at(i16, 20);
}

pub fn rankReq(self: @This()) u8 {
    return self.row.at(u8, 22);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 23);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 24);
}

pub fn surveillanceReq(self: @This()) u8 {
    return self.row.at(u8, 25);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 26);
}

pub fn passengers(self: @This()) bool {
    return self.row.bitAt(27, 0);
}
