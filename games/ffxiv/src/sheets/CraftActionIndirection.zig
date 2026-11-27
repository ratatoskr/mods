//! `CraftActionIndirection`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CraftActionIndirection = @This();

pub const sheet_name = "CraftActionIndirection";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf7903c75;
pub const Sheet = excel.Typed(CraftActionIndirection);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "PreviousComboAction", "ClassJob" };

/// Links to `CraftAction`.
pub fn name(self: @This()) excel.Link(sheets.CraftAction) {
    return .of(self.row.at(i32, 0));
}

/// Links to `CraftAction`.
pub fn previousComboAction(self: @This()) excel.Link(sheets.CraftAction) {
    return .of(self.row.at(i32, 4));
}

/// Links to `ClassJob`.
pub fn classJob(self: @This()) excel.Link(sheets.ClassJob) {
    return .of(self.row.at(i8, 8));
}
