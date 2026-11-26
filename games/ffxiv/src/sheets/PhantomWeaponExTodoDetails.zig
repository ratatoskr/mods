//! `PhantomWeaponExTodoDetails`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PhantomWeaponExTodoDetails = @This();

pub const sheet_name = "PhantomWeaponExTodoDetails";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xc21c2311;
pub const Sheet = excel.Typed(PhantomWeaponExTodoDetails);

row: excel.Row,

/// Links to `LogMessage`.
pub fn logMessage(self: @This()) excel.Link(sheets.LogMessage) {
    return .of(self.row.at(u32, 0));
}

/// Links to `ExtendedQuestCounter`.
pub fn extendedQuestCounter(self: @This()) excel.Link(sheets.ExtendedQuestCounter) {
    return .of(self.row.at(u32, 4));
}

/// Links to `PhantomWeaponExTodoDetailTxt`.
pub fn detailText(self: @This()) excel.Link(sheets.PhantomWeaponExTodoDetailTxt) {
    return .of(self.row.at(u32, 8));
}

/// Links to `ContentFinderCondition`.
pub fn contentFinderCondition(self: @This()) excel.Link(sheets.ContentFinderCondition) {
    return .of(self.row.at(u32, 12));
}

/// Links to `TerritoryType`.
pub fn territoryType(self: @This()) excel.Link(sheets.TerritoryType) {
    return .of(self.row.at(u32, 16));
}

pub fn unknown5(self: @This()) u16 {
    return self.row.at(u16, 20);
}
