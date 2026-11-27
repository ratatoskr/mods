//! `ParamGrow`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ParamGrow = @This();

pub const sheet_name = "ParamGrow";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x64a92445;
pub const Sheet = excel.Typed(ParamGrow);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "ExpToNext", "AdditionalActions", "ApplyAction", "ScaledQuestXP", "MpModifier", "BaseSpeed", "LevelModifier", "QuestExpModifier", "HpModifier", "HuntingLogExpReward", "MonsterNoteSeals", "ItemLevelSync", "ProperDungeon", "ProperGuildOrder", "CraftingLevel" };

pub fn expToNext(self: @This()) i32 {
    return self.row.at(i32, 0);
}

pub fn mpModifier(self: @This()) i32 {
    return self.row.at(i32, 4);
}

pub fn baseSpeed(self: @This()) i32 {
    return self.row.at(i32, 8);
}

pub fn levelModifier(self: @This()) i32 {
    return self.row.at(i32, 12);
}

pub fn huntingLogExpReward(self: @This()) i32 {
    return self.row.at(i32, 16);
}

pub fn monsterNoteSeals(self: @This()) i32 {
    return self.row.at(i32, 20);
}

pub fn scaledQuestXP(self: @This()) u16 {
    return self.row.at(u16, 24);
}

pub fn hpModifier(self: @This()) u16 {
    return self.row.at(u16, 26);
}

pub fn itemLevelSync(self: @This()) u16 {
    return self.row.at(u16, 28);
}

pub fn properDungeon(self: @This()) u16 {
    return self.row.at(u16, 30);
}

pub fn properGuildOrder(self: @This()) u16 {
    return self.row.at(u16, 32);
}

pub fn craftingLevel(self: @This()) u16 {
    return self.row.at(u16, 34);
}

pub fn additionalActions(self: @This()) u8 {
    return self.row.at(u8, 36);
}

pub fn applyAction(self: @This()) u8 {
    return self.row.at(u8, 37);
}

pub fn questExpModifier(self: @This()) u8 {
    return self.row.at(u8, 38);
}
