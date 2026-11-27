//! `LootModeType`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const LootModeType = @This();

pub const sheet_name = "LootModeType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xcd4cb81c;
pub const Sheet = excel.Typed(LootModeType);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{"AdditionalLootRulesAvailable"};

pub fn additionalLootRulesAvailable(self: @This()) bool {
    return self.row.bitAt(0, 0);
}
