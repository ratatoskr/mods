//! `WKSEmergencyProblem`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSEmergencyProblem = @This();

pub const sheet_name = "WKSEmergencyProblem";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x2ebeea9f;
pub const Sheet = excel.Typed(WKSEmergencyProblem);

row: excel.Row,

/// The first option to teleport
/// Links to `WKSEmergencyInfoText`.
pub fn emergencyInfoTeleportText1(self: @This()) excel.Link(sheets.WKSEmergencyInfoText) {
    return .of(self.row.at(u32, 0));
}

/// The second option to teleport
/// Links to `WKSEmergencyInfoText`.
pub fn emergencyInfoTeleportText2(self: @This()) excel.Link(sheets.WKSEmergencyInfoText) {
    return .of(self.row.at(u32, 4));
}

pub fn eventLayout(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn requiredProgress(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 16);
}
