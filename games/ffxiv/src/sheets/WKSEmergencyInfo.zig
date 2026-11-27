//! `WKSEmergencyInfo`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSEmergencyInfo = @This();

pub const sheet_name = "WKSEmergencyInfo";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xc04fef85;
pub const Sheet = excel.Typed(WKSEmergencyInfo);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "WKSEmergencyWarningText", "EmergencyProblem[0]", "EmergencyProblem[1]", "WKSEmergencyMissionRowId" };

pub const emergency_problem_len = 2;
/// Links to `WKSEmergencyProblem`.
pub fn emergencyProblem(self: @This(), n0: usize) excel.Link(sheets.WKSEmergencyProblem) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

/// Has between 5 and 6 subrows
pub fn wksEmergencyMissionRowId(self: @This()) u16 {
    return self.row.at(u16, 4);
}

/// Links to `WKSEmergencyInfoText`.
pub fn name(self: @This()) excel.Link(sheets.WKSEmergencyInfoText) {
    return .of(self.row.at(u8, 6));
}

/// Links to `WKSEmergencyInfoText`.
pub fn wksEmergencyWarningText(self: @This()) excel.Link(sheets.WKSEmergencyInfoText) {
    return .of(self.row.at(u8, 7));
}

const offsets_1 = [2]u16{ 0, 2 };
