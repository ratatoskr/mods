//! `GatheringLeve`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GatheringLeve = @This();

pub const sheet_name = "GatheringLeve";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xfa74e4d0;
pub const Sheet = excel.Typed(GatheringLeve);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Route[0]", "Route[1]", "Route[2]", "Route[3]", "RequiredItem[0]", "RequiredItemQuantity[0]", "RequiredItem[1]", "RequiredItemQuantity[1]", "RequiredItem[2]", "RequiredItemQuantity[2]", "RequiredItem[3]", "RequiredItemQuantity[3]", "ItemNumber", "Rule", "Varient", "Objective[0]", "Objective[1]", "BNpcEntry", "UseSecondaryTool" };

pub const route_len = 4;
/// Links to `GatheringLeveRoute`.
pub fn route(self: @This(), n0: usize) excel.Link(sheets.GatheringLeveRoute) {
    return .of(self.row.at(i32, offsets_1[n0]));
}

pub const required_item_len = 4;
/// Links to `EventItem`.
pub fn requiredItem(self: @This(), n0: usize) excel.Link(sheets.EventItem) {
    return .of(self.row.at(i32, offsets_2[n0]));
}

/// Links to `GatheringLeveRule`.
pub fn rule(self: @This()) excel.Link(sheets.GatheringLeveRule) {
    return .of(self.row.at(i32, 32));
}

/// Links to `GatheringLeveBNpcEntry`.
pub fn bNpcEntry(self: @This()) excel.Link(sheets.GatheringLeveBNpcEntry) {
    return .of(self.row.at(i32, 36));
}

pub const objective_len = 2;
pub fn objective(self: @This(), n0: usize) u16 {
    return self.row.at(u16, offsets_3[n0]);
}

pub const required_item_quantity_len = 4;
pub fn requiredItemQuantity(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_4[n0]);
}

pub fn itemNumber(self: @This()) u8 {
    return self.row.at(u8, 48);
}

pub fn varient(self: @This()) u8 {
    return self.row.at(u8, 49);
}

pub fn useSecondaryTool(self: @This()) bool {
    return self.row.bitAt(50, 0);
}

const offsets_1 = [4]u16{ 0, 4, 8, 12 };
const offsets_2 = [4]u16{ 16, 20, 24, 28 };
const offsets_3 = [2]u16{ 40, 42 };
const offsets_4 = [4]u16{ 44, 45, 46, 47 };
