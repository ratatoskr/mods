//! `HudTransient`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HudTransient = @This();

pub const sheet_name = "HudTransient";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x83076f24;
pub const Sheet = excel.Typed(HudTransient);

row: excel.Row,

/// System = 0, Hotbars = 1, Duty = 2
pub fn editCategory(self: @This()) i8 {
    return self.row.at(i8, 0);
}

/// Job gauge = 1, Non-cross hotbar = 2, Party list = 3
pub fn unknown1(self: @This()) i8 {
    return self.row.at(i8, 1);
}

/// Links to `AddonHudSize`.
pub fn size(self: @This()) excel.Link(sheets.AddonHudSize) {
    return .of(self.row.at(i8, 2));
}

/// Links to `AddonHudSize`.
pub fn simpleModeSize(self: @This()) excel.Link(sheets.AddonHudSize) {
    return .of(self.row.at(i8, 3));
}
