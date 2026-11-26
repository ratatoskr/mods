//! `HalloweenNpcSelect`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HalloweenNpcSelect = @This();

pub const sheet_name = "HalloweenNpcSelect";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x0caf95df;
pub const Sheet = excel.Typed(HalloweenNpcSelect);

row: excel.Row,

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// Links to `Quest`.
pub fn requiredQuest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 8));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn previewIcon(self: @This()) u32 {
    return self.row.at(u32, 12);
}

/// Links to `Transformation`.
pub fn transformation(self: @This()) excel.Link(sheets.Transformation) {
    return .of(self.row.at(u16, 16));
}

/// The Festival where this option became available.
/// Links to `Festival`.
pub fn festival(self: @This()) excel.Link(sheets.Festival) {
    return .of(self.row.at(u16, 18));
}

/// Links to `ExVersion`.
pub fn expansion(self: @This()) excel.Link(sheets.ExVersion) {
    return .of(self.row.at(u8, 20));
}
