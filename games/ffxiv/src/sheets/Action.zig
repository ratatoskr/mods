//! `Action`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Action = @This();

pub const sheet_name = "Action";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc5217018;
pub const Sheet = excel.Typed(Action);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `ChocoboTaxiStand`, `CraftLeve`, `CustomTalk`, `DefaultTalk`, `FccShop`, `GCShop`, `GilShop`, `GuildleveAssignment`, `GuildOrderGuide`, `GuildOrderOfficer`, `Quest`, `SpecialShop`, `Story`, `SwitchTalk`, `TopicSelect`, `TripleTriad` or `Warp`, whichever has the row.
pub fn unlockLink(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u16 {
    return self.row.at(u16, 8);
}

/// Links to `ActionCastVFX`.
pub fn vfx(self: @This()) excel.Link(sheets.ActionCastVFX) {
    return .of(self.row.at(u16, 10));
}

/// Links to `ActionTimeline`.
pub fn actionTimelineHit(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 12));
}

pub fn primaryCostValue(self: @This()) u16 {
    return self.row.at(u16, 14);
}

/// Links by `SecondaryCostType`: 32 to `Status`, 35 to `Status`, 46 to `Status`.
pub fn secondaryCostValue(self: @This()) u16 {
    return self.row.at(u16, 16);
}

/// Links to `Action`.
pub fn actionCombo(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(u16, 18));
}

pub fn cast100ms(self: @This()) u16 {
    return self.row.at(u16, 20);
}

pub fn recast100ms(self: @This()) u16 {
    return self.row.at(u16, 22);
}

/// Links to `ActionProcStatus`.
pub fn actionProcStatus(self: @This()) excel.Link(sheets.ActionProcStatus) {
    return .of(self.row.at(u16, 24));
}

/// Links to `Status`.
pub fn statusGainSelf(self: @This()) excel.Link(sheets.Status) {
    return .of(self.row.at(u16, 26));
}

/// Links to `Omen`.
pub fn omen(self: @This()) excel.Link(sheets.Omen) {
    return .of(self.row.at(u16, 28));
}

/// Links to `Omen`.
pub fn omenAlt(self: @This()) excel.Link(sheets.Omen) {
    return .of(self.row.at(u16, 30));
}

/// Links to `ActionTimeline`.
pub fn animationEnd(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(i16, 32));
}

/// Links to `ActionCategory`.
pub fn actionCategory(self: @This()) excel.Link(sheets.ActionCategory) {
    return .of(self.row.at(u8, 34));
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 35);
}

/// Links to `ActionCastTimeline`.
pub fn animationStart(self: @This()) excel.Link(sheets.ActionCastTimeline) {
    return .of(self.row.at(u8, 36));
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 37);
}

pub fn behaviourType(self: @This()) u8 {
    return self.row.at(u8, 38);
}

pub fn classJobLevel(self: @This()) u8 {
    return self.row.at(u8, 39);
}

pub fn castType(self: @This()) u8 {
    return self.row.at(u8, 40);
}

pub fn effectRange(self: @This()) u8 {
    return self.row.at(u8, 41);
}

pub fn xAxisModifier(self: @This()) u8 {
    return self.row.at(u8, 42);
}

pub fn primaryCostType(self: @This()) u8 {
    return self.row.at(u8, 43);
}

pub fn secondaryCostType(self: @This()) u8 {
    return self.row.at(u8, 44);
}

pub fn extraCastTime100ms(self: @This()) u8 {
    return self.row.at(u8, 45);
}

pub fn cooldownGroup(self: @This()) u8 {
    return self.row.at(u8, 46);
}

pub fn additionalCooldownGroup(self: @This()) u8 {
    return self.row.at(u8, 47);
}

pub fn maxCharges(self: @This()) u8 {
    return self.row.at(u8, 48);
}

pub fn aspect(self: @This()) u8 {
    return self.row.at(u8, 49);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 50);
}

/// Links to `ClassJobCategory`.
pub fn classJobCategory(self: @This()) excel.Link(sheets.ClassJobCategory) {
    return .of(self.row.at(u8, 51));
}

/// 0 = no effect on auto attacks, 1 = typical cast (unsheathe weapon, but don't touch autos), 2 = typical weaponskill (unsheathe, start autos if action target is primary target), 3 = sleep-like effect (unsheathe, stop autos), 4 = typical point-blank aoe (unsheathe, start autos if primary target is within action range), 5 = ??? (doesn't touch weapon state), 6 = typical channeled action (unsheathe, stop autos, do not auto-face target), 7 = force sheathe and stop autos, 8 = ??? (unused)
pub fn autoAttackBehaviour(self: @This()) u8 {
    return self.row.at(u8, 52);
}

/// set for eg crafting actions, when different jobs have different rows, but they need to be considered interchangeable
pub fn equivalenceGroup(self: @This()) u8 {
    return self.row.at(u8, 53);
}

pub fn unknown_70(self: @This()) u8 {
    return self.row.at(u8, 54);
}

/// Links to `ClassJob`.
pub fn classJob(self: @This()) excel.Link(sheets.ClassJob) {
    return .of(self.row.at(i8, 55));
}

pub fn range(self: @This()) i8 {
    return self.row.at(i8, 56);
}

/// 0 = can not target dead, 1 = can only target dead players (+ some other conditions), 2 = ???
pub fn deadTargetBehaviour(self: @This()) i8 {
    return self.row.at(i8, 57);
}

/// Links to `AttackType`.
pub fn attackType(self: @This()) excel.Link(sheets.AttackType) {
    return .of(self.row.at(i8, 58));
}

pub fn unknown8(self: @This()) bool {
    return self.row.bitAt(59, 0);
}

pub fn isRoleAction(self: @This()) bool {
    return self.row.bitAt(59, 1);
}

pub fn unknown28(self: @This()) bool {
    return self.row.bitAt(59, 2);
}

pub fn canTargetSelf(self: @This()) bool {
    return self.row.bitAt(59, 3);
}

pub fn canTargetParty(self: @This()) bool {
    return self.row.bitAt(59, 4);
}

pub fn canTargetAlliance(self: @This()) bool {
    return self.row.bitAt(59, 5);
}

pub fn canTargetHostile(self: @This()) bool {
    return self.row.bitAt(59, 6);
}

pub fn canTargetAlly(self: @This()) bool {
    return self.row.bitAt(59, 7);
}

pub fn unknown10(self: @This()) bool {
    return self.row.bitAt(60, 0);
}

pub fn targetArea(self: @This()) bool {
    return self.row.bitAt(60, 1);
}

pub fn canTargetOwnPet(self: @This()) bool {
    return self.row.bitAt(60, 2);
}

pub fn canTargetPartyPet(self: @This()) bool {
    return self.row.bitAt(60, 3);
}

pub fn requiresLineOfSight(self: @This()) bool {
    return self.row.bitAt(60, 4);
}

pub fn needToFaceTarget(self: @This()) bool {
    return self.row.bitAt(60, 5);
}

pub fn unknown14(self: @This()) bool {
    return self.row.bitAt(60, 6);
}

pub fn preservesCombo(self: @This()) bool {
    return self.row.bitAt(60, 7);
}

pub fn unknown15(self: @This()) bool {
    return self.row.bitAt(61, 0);
}

pub fn affectsPosition(self: @This()) bool {
    return self.row.bitAt(61, 1);
}

pub fn isPvP(self: @This()) bool {
    return self.row.bitAt(61, 2);
}

pub fn unknown16(self: @This()) bool {
    return self.row.bitAt(61, 3);
}

pub fn logCastMessage(self: @This()) bool {
    return self.row.bitAt(61, 4);
}

pub fn unknown18(self: @This()) bool {
    return self.row.bitAt(61, 5);
}

pub fn logMissMessage(self: @This()) bool {
    return self.row.bitAt(61, 6);
}

pub fn logActionMessage(self: @This()) bool {
    return self.row.bitAt(61, 7);
}

pub fn unknown21(self: @This()) bool {
    return self.row.bitAt(62, 0);
}

pub fn unknown22(self: @This()) bool {
    return self.row.bitAt(62, 1);
}

pub fn unknown23(self: @This()) bool {
    return self.row.bitAt(62, 2);
}

pub fn canUseWhileMounted(self: @This()) bool {
    return self.row.bitAt(62, 3);
}

pub fn unknown25(self: @This()) bool {
    return self.row.bitAt(62, 4);
}

pub fn isPlayerAction(self: @This()) bool {
    return self.row.bitAt(62, 5);
}

pub fn unknown27(self: @This()) bool {
    return self.row.bitAt(62, 6);
}
