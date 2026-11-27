//! `Tutorial`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Objective`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Tutorial = @This();

pub const sheet_name = "Tutorial";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x4a3fef40;
pub const Sheet = excel.Typed(Tutorial);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown5", "Unknown0", "Unknown1", "Unknown2", "Unknown3", "Exp", "Gil", "RewardTank", "RewardMelee", "RewardRanged", "Unknown4", "Objective" };

pub fn exp(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn gil(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// Links to `Item`.
pub fn rewardTank(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 8));
}

/// Links to `Item`.
pub fn rewardMelee(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 12));
}

/// Links to `Item`.
pub fn rewardRanged(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 16));
}

pub fn unknown4(self: @This()) u32 {
    return self.row.at(u32, 20);
}

/// Links to `InstanceContentTextData`.
pub fn objective(self: @This()) excel.Link(sheets.InstanceContentTextData) {
    return .of(self.row.at(u32, 24));
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 28);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 29);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 30);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 31);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 32);
}
