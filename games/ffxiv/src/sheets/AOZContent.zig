//! `AOZContent`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AOZContent = @This();

pub const sheet_name = "AOZContent";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xb05ff0c9;
pub const Sheet = excel.Typed(AOZContent);

row: excel.Row,

pub fn gilReward(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn alliedSealsReward(self: @This()) u16 {
    return self.row.at(u16, 2);
}

pub fn tomestonesReward(self: @This()) u16 {
    return self.row.at(u16, 4);
}

/// Links to `ContentEntry`.
pub fn contentEntry(self: @This()) excel.Link(sheets.ContentEntry) {
    return .of(self.row.at(u32, 8));
}

pub fn standardFinishTime(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn idealFinishTime(self: @This()) u16 {
    return self.row.at(u16, 14);
}

/// Links by `Act1FightType`: 1 to `AOZArrangement`, 2 to `AOZBoss`, 3 to `AOZBoss`.
pub fn act1(self: @This()) u16 {
    return self.row.at(u16, 16);
}

/// Links by `Act2FightType`: 1 to `AOZArrangement`, 2 to `AOZBoss`, 3 to `AOZBoss`.
pub fn act2(self: @This()) u16 {
    return self.row.at(u16, 18);
}

/// Links by `Act3FightType`: 1 to `AOZArrangement`, 2 to `AOZBoss`, 3 to `AOZBoss`.
pub fn act3(self: @This()) u16 {
    return self.row.at(u16, 20);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 22);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 24);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 26);
}

pub fn act1FightType(self: @This()) u8 {
    return self.row.at(u8, 28);
}

pub fn act2FightType(self: @This()) u8 {
    return self.row.at(u8, 29);
}

pub fn act3FightType(self: @This()) u8 {
    return self.row.at(u8, 30);
}

pub fn arenaType1(self: @This()) u8 {
    return self.row.at(u8, 31);
}

pub fn arenaType2(self: @This()) u8 {
    return self.row.at(u8, 32);
}

pub fn arenaType3(self: @This()) u8 {
    return self.row.at(u8, 33);
}

pub fn order(self: @This()) u8 {
    return self.row.at(u8, 34);
}
