//! `MobHuntReward`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MobHuntReward = @This();

pub const sheet_name = "MobHuntReward";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x4ace707c;
pub const Sheet = excel.Typed(MobHuntReward);

row: excel.Row,

pub fn expReward(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn gilReward(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn currencyReward(self: @This()) u16 {
    return self.row.at(u16, 6);
}

/// Links to `ExVersion`.
pub fn expansion(self: @This()) excel.Link(sheets.ExVersion) {
    return .of(self.row.at(u8, 8));
}
