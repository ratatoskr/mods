//! `RelicItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const RelicItem = @This();

pub const sheet_name = "RelicItem";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc8fc45d9;
pub const Sheet = excel.Typed(RelicItem);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown5", "GladiatorItem", "PugilistItem", "MarauderItem", "LancerItem", "ArcherItem", "ConjurerItem", "ThaumaturgeItem", "ArcanistSMNItem", "ArcanistSCHItem", "ShieldItem", "RogueItem", "Unknown0", "Unknown1", "Unknown2", "Unknown3", "Unknown4" };

/// Links to `Item`.
pub fn gladiatorItem(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 0));
}

/// Links to `Item`.
pub fn pugilistItem(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 4));
}

/// Links to `Item`.
pub fn marauderItem(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 8));
}

/// Links to `Item`.
pub fn lancerItem(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 12));
}

/// Links to `Item`.
pub fn archerItem(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 16));
}

/// Links to `Item`.
pub fn conjurerItem(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 20));
}

/// Links to `Item`.
pub fn thaumaturgeItem(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 24));
}

/// Links to `Item`.
pub fn arcanistSMNItem(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 28));
}

/// Links to `Item`.
pub fn arcanistSCHItem(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 32));
}

/// Links to `Item`.
pub fn shieldItem(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 36));
}

/// Links to `Item`.
pub fn rogueItem(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 40));
}

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 44);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 48);
}

pub fn unknown2(self: @This()) u32 {
    return self.row.at(u32, 52);
}

pub fn unknown3(self: @This()) u32 {
    return self.row.at(u32, 56);
}

pub fn unknown4(self: @This()) u32 {
    return self.row.at(u32, 60);
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 64);
}
