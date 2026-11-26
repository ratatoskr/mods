//! `RaidFinderParam`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const RaidFinderParam = @This();

pub const sheet_name = "RaidFinderParam";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xcd4cb81c;
pub const Sheet = excel.Typed(RaidFinderParam);

row: excel.Row,

/// Displays Addon#10115 instead of Addon#10093, to list pure and barrier healer count.
pub fn separatedHealerRoles(self: @This()) bool {
    return self.row.bitAt(0, 0);
}
