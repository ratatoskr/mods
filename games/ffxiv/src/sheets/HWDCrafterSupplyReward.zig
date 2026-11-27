//! `HWDCrafterSupplyReward`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HWDCrafterSupplyReward = @This();

pub const sheet_name = "HWDCrafterSupplyReward";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x829e9d8e;
pub const Sheet = excel.Typed(HWDCrafterSupplyReward);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "ScriptRewardAmount", "ExpReward", "Points" };

pub fn expReward(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn scriptRewardAmount(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn points(self: @This()) u16 {
    return self.row.at(u16, 6);
}
