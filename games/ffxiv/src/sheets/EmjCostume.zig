//! `EmjCostume`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EmjCostume = @This();

pub const sheet_name = "EmjCostume";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x1f808f3f;
pub const Sheet = excel.Typed(EmjCostume);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Image", "UnlockQuest", "Unknown0", "UnlockText", "Data", "Sort", "Scale", "OffsetX", "OffsetY" };

pub fn scale(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn offsetX(self: @This()) f32 {
    return self.row.at(f32, 4);
}

pub fn offsetY(self: @This()) f32 {
    return self.row.at(f32, 8);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn image(self: @This()) u32 {
    return self.row.at(u32, 12);
}

/// Links to `Quest`.
pub fn unlockQuest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 16));
}

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 20);
}

/// Links to `Addon`.
pub fn unlockText(self: @This()) excel.Link(sheets.Addon) {
    return .of(self.row.at(u32, 24));
}

/// Links to `EmjCostumeData`.
pub fn data(self: @This()) excel.Link(sheets.EmjCostumeData) {
    return .of(self.row.at(u16, 28));
}

pub fn sort(self: @This()) u8 {
    return self.row.at(u8, 30);
}
