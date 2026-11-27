//! `Buddy`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Buddy = @This();

pub const sheet_name = "Buddy";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd2892cc5;
pub const Sheet = excel.Typed(Buddy);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Base", "QuestRequirement2", "QuestRequirement1", "BaseEquip", "SoundEffect4", "SoundEffect3", "SoundEffect2", "SoundEffect1" };

pub fn soundEffect4(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn soundEffect3(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn soundEffect2(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn soundEffect1(self: @This()) []const u8 {
    return self.row.stringAt(12);
}

/// Links to `Quest`.
pub fn questRequirement2(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(i32, 16));
}

/// Links to `Quest`.
pub fn questRequirement1(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(i32, 20));
}

pub fn baseEquip(self: @This()) i32 {
    return self.row.at(i32, 24);
}

pub fn base(self: @This()) u8 {
    return self.row.at(u8, 28);
}
