//! `WKSEmergencyMission`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSEmergencyMission = @This();

pub const sheet_name = "WKSEmergencyMission";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xd870e208;
pub const Sheet = excel.Typed(WKSEmergencyMission);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{"WKSEmergencyMissionGroupRowId"};

/// As of Patch 7.31 this can always be direct queried with subrow 0 to get the follow chain to WKSMissionUnit from the sheet
pub fn wksEmergencyMissionGroupRowId(self: @This()) u16 {
    return self.row.at(u16, 0);
}
