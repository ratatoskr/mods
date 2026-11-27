//! `Companion`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Singular`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Companion = @This();

pub const sheet_name = "Companion";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xeaeebef0;
pub const Sheet = excel.Typed(Companion);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Singular", "Adjective", "Plural", "PossessivePronoun", "StartsWithVowel", "Countability", "Pronoun", "Article", "Model", "Scale", "InactiveIdle0", "InactiveIdle1", "InactiveBattle", "InactiveWandering", "Behavior", "Special", "Unknown10", "Unknown11", "WanderingWait", "Priority", "Unknown5", "Unknown6", "Unknown7", "Unknown8", "Unknown9", "Enemy", "Battle", "Roulette", "Icon", "Order", "IdleAnimation", "Unknown2", "Cost", "HP", "Unknown3", "SkillAngle", "SkillCost", "Unknown4", "Unknown1", "MinionRace" };

pub fn singular(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn plural(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn adjective(self: @This()) i8 {
    return self.row.at(i8, 8);
}

pub fn possessivePronoun(self: @This()) i8 {
    return self.row.at(i8, 9);
}

pub fn startsWithVowel(self: @This()) i8 {
    return self.row.at(i8, 10);
}

pub fn countability(self: @This()) i8 {
    return self.row.at(i8, 11);
}

pub fn pronoun(self: @This()) i8 {
    return self.row.at(i8, 12);
}

pub fn article(self: @This()) i8 {
    return self.row.at(i8, 13);
}

/// Links to `ModelChara`.
pub fn model(self: @This()) excel.Link(sheets.ModelChara) {
    return .of(self.row.at(u16, 16));
}

pub fn priority(self: @This()) u16 {
    return self.row.at(u16, 18);
}

pub fn enemy(self: @This()) u16 {
    return self.row.at(u16, 20);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u16 {
    return self.row.at(u16, 22);
}

pub fn order(self: @This()) u16 {
    return self.row.at(u16, 24);
}

pub fn hp(self: @This()) u16 {
    return self.row.at(u16, 26);
}

pub fn skillAngle(self: @This()) u16 {
    return self.row.at(u16, 28);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 30);
}

pub fn scale(self: @This()) u8 {
    return self.row.at(u8, 32);
}

pub fn inactiveIdle0(self: @This()) u8 {
    return self.row.at(u8, 33);
}

pub fn inactiveIdle1(self: @This()) u8 {
    return self.row.at(u8, 34);
}

pub fn inactiveBattle(self: @This()) u8 {
    return self.row.at(u8, 35);
}

pub fn inactiveWandering(self: @This()) u8 {
    return self.row.at(u8, 36);
}

/// Links to `CompanionMove`.
pub fn behavior(self: @This()) excel.Link(sheets.CompanionMove) {
    return .of(self.row.at(u8, 37));
}

pub fn special(self: @This()) u8 {
    return self.row.at(u8, 38);
}

pub fn unknown10(self: @This()) u8 {
    return self.row.at(u8, 39);
}

pub fn unknown11(self: @This()) u8 {
    return self.row.at(u8, 40);
}

pub fn wanderingWait(self: @This()) u8 {
    return self.row.at(u8, 41);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 42);
}

pub fn cost(self: @This()) u8 {
    return self.row.at(u8, 43);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 44);
}

pub fn skillCost(self: @This()) u8 {
    return self.row.at(u8, 45);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 46);
}

/// Links to `MinionRace`.
pub fn minionRace(self: @This()) excel.Link(sheets.MinionRace) {
    return .of(self.row.at(u8, 47));
}

pub fn unknown5(self: @This()) bool {
    return self.row.bitAt(48, 0);
}

pub fn unknown6(self: @This()) bool {
    return self.row.bitAt(48, 1);
}

pub fn unknown7(self: @This()) bool {
    return self.row.bitAt(48, 2);
}

pub fn unknown8(self: @This()) bool {
    return self.row.bitAt(48, 3);
}

pub fn unknown9(self: @This()) bool {
    return self.row.bitAt(48, 4);
}

pub fn battle(self: @This()) bool {
    return self.row.bitAt(48, 5);
}

pub fn roulette(self: @This()) bool {
    return self.row.bitAt(48, 6);
}

pub fn idleAnimation(self: @This()) bool {
    return self.row.bitAt(48, 7);
}
