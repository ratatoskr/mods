//! `IKDPlayerMissionCondition`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `MissionText`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const IKDPlayerMissionCondition = @This();

pub const sheet_name = "IKDPlayerMissionCondition";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5eb59ccb;
pub const Sheet = excel.Typed(IKDPlayerMissionCondition);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Count", "MissionText" };

pub fn missionText(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// How many to actually catch
pub fn count(self: @This()) u8 {
    return self.row.at(u8, 4);
}
