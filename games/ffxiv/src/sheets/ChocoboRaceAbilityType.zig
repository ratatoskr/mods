//! `ChocoboRaceAbilityType`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `IsActive`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ChocoboRaceAbilityType = @This();

pub const sheet_name = "ChocoboRaceAbilityType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xcd4cb81c;
pub const Sheet = excel.Typed(ChocoboRaceAbilityType);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{"IsActive"};

pub fn isActive(self: @This()) bool {
    return self.row.bitAt(0, 0);
}
