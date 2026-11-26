//! `GCSupplyDutyReward`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GCSupplyDutyReward = @This();

pub const sheet_name = "GCSupplyDutyReward";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x6be0e840;
pub const Sheet = excel.Typed(GCSupplyDutyReward);

row: excel.Row,

pub fn experienceSupply(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn experienceProvisioning(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn sealsExpertDelivery(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn sealsSupply(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn sealsProvisioning(self: @This()) u32 {
    return self.row.at(u32, 16);
}
