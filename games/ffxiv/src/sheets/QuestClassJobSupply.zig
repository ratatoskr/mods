//! `QuestClassJobSupply`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const QuestClassJobSupply = @This();

pub const sheet_name = "QuestClassJobSupply";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xde5221b6;
pub const Sheet = excel.Typed(QuestClassJobSupply);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "ClassJobCategory", "Unknown0", "ENpcResident", "Item", "AmountRequired", "ItemHQ", "Unknown_70_2", "Unknown_70_3", "Unknown1", "Unknown2", "Unknown3", "Unknown_70_1" };

pub fn unknown_70_1(self: @This()) u8 {
    return self.row.at(u8, 0);
}

/// Links to `ENpcResident`.
pub fn eNpcResident(self: @This()) excel.Link(sheets.ENpcResident) {
    return .of(self.row.at(u32, 4));
}

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 8));
}

pub fn unknown_70_2(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn unknown_70_3(self: @This()) u32 {
    return self.row.at(u32, 16);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 20);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 24);
}

/// Links to `ClassJobCategory`.
pub fn classJobCategory(self: @This()) excel.Link(sheets.ClassJobCategory) {
    return .of(self.row.at(u8, 26));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 27);
}

pub fn amountRequired(self: @This()) u8 {
    return self.row.at(u8, 28);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 29);
}

pub fn itemHQ(self: @This()) bool {
    return self.row.bitAt(30, 0);
}
