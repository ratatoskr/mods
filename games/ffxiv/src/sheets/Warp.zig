//! `Warp`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Warp = @This();

pub const sheet_name = "Warp";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x1a234b7b;
pub const Sheet = excel.Typed(Warp);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn question(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

/// Links to `Level`.
pub fn popRange(self: @This()) excel.Link(sheets.Level) {
    return .of(self.row.at(u32, 8));
}

/// Links to `DefaultTalk`.
pub fn conditionSuccessEvent(self: @This()) excel.Link(sheets.DefaultTalk) {
    return .of(self.row.at(u32, 12));
}

/// Links to `DefaultTalk`.
pub fn conditionFailEvent(self: @This()) excel.Link(sheets.DefaultTalk) {
    return .of(self.row.at(u32, 16));
}

/// Links to `DefaultTalk`.
pub fn confirmEvent(self: @This()) excel.Link(sheets.DefaultTalk) {
    return .of(self.row.at(u32, 20));
}

/// Links to `TerritoryType`.
pub fn territoryType(self: @This()) excel.Link(sheets.TerritoryType) {
    return .of(self.row.at(u16, 24));
}

/// Links to `WarpCondition`.
pub fn warpCondition(self: @This()) excel.Link(sheets.WarpCondition) {
    return .of(self.row.at(u16, 26));
}

/// Links to `WarpLogic`.
pub fn warpLogic(self: @This()) excel.Link(sheets.WarpLogic) {
    return .of(self.row.at(u16, 28));
}

/// Links to `Cutscene`.
pub fn startCutscene(self: @This()) excel.Link(sheets.Cutscene) {
    return .of(self.row.at(u16, 30));
}

/// Links to `Cutscene`.
pub fn endCutscene(self: @This()) excel.Link(sheets.Cutscene) {
    return .of(self.row.at(u16, 32));
}

pub fn canSkipCutscene(self: @This()) bool {
    return self.row.bitAt(34, 0);
}
