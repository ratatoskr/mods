//! `Status`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Status = @This();

pub const sheet_name = "Status";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd66a51d6;
pub const Sheet = excel.Typed(Status);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "Description", "Icon", "ExclusionGroup", "MaxStacks", "ClassJobCategory", "StatusCategory", "HitEffect", "VFX", "LockMovement", "Unknown3", "LockActions", "LockControl", "Transfiguration", "IsGaze", "CanDispel", "Unknown8", "InflictedByActor", "IsPermanent", "PartyListPriority", "CanIncreaseRewards", "NoLogVfx", "Unknown5", "ParamModifier", "ParamEffect", "CanStatusOff", "Log", "IsFcBuff", "Unknown2", "Invisibility", "TargetType", "Flags", "Flag2", "Unknown6", "Unknown_70_2", "Unknown7", "Unknown_70_1" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn paramModifier(self: @This()) i32 {
    return self.row.at(i32, 12);
}

/// Links to `StatusLoopVFX`.
pub fn vfx(self: @This()) excel.Link(sheets.StatusLoopVFX) {
    return .of(self.row.at(u16, 16));
}

pub fn log(self: @This()) u16 {
    return self.row.at(u16, 18);
}

pub fn exclusionGroup(self: @This()) u8 {
    return self.row.at(u8, 20);
}

pub fn maxStacks(self: @This()) u8 {
    return self.row.at(u8, 21);
}

/// Links to `ClassJobCategory`.
pub fn classJobCategory(self: @This()) excel.Link(sheets.ClassJobCategory) {
    return .of(self.row.at(u8, 22));
}

pub fn statusCategory(self: @This()) u8 {
    return self.row.at(u8, 23);
}

/// Links to `StatusHitEffect`.
pub fn hitEffect(self: @This()) excel.Link(sheets.StatusHitEffect) {
    return .of(self.row.at(u8, 24));
}

pub fn partyListPriority(self: @This()) u8 {
    return self.row.at(u8, 25);
}

pub fn canIncreaseRewards(self: @This()) u8 {
    return self.row.at(u8, 26);
}

pub fn paramEffect(self: @This()) u8 {
    return self.row.at(u8, 27);
}

pub fn targetType(self: @This()) u8 {
    return self.row.at(u8, 28);
}

/// actually an index of the flag
pub fn flags(self: @This()) u8 {
    return self.row.at(u8, 29);
}

pub fn flag2(self: @This()) u8 {
    return self.row.at(u8, 30);
}

pub fn unknown_70_1(self: @This()) u8 {
    return self.row.at(u8, 31);
}

pub fn unknown2(self: @This()) i8 {
    return self.row.at(i8, 32);
}

pub fn lockMovement(self: @This()) bool {
    return self.row.bitAt(33, 0);
}

pub fn unknown3(self: @This()) bool {
    return self.row.bitAt(33, 1);
}

pub fn lockActions(self: @This()) bool {
    return self.row.bitAt(33, 2);
}

pub fn lockControl(self: @This()) bool {
    return self.row.bitAt(33, 3);
}

pub fn transfiguration(self: @This()) bool {
    return self.row.bitAt(33, 4);
}

pub fn isGaze(self: @This()) bool {
    return self.row.bitAt(33, 5);
}

pub fn canDispel(self: @This()) bool {
    return self.row.bitAt(33, 6);
}

pub fn unknown8(self: @This()) bool {
    return self.row.bitAt(33, 7);
}

pub fn inflictedByActor(self: @This()) bool {
    return self.row.bitAt(34, 0);
}

pub fn isPermanent(self: @This()) bool {
    return self.row.bitAt(34, 1);
}

pub fn noLogVfx(self: @This()) bool {
    return self.row.bitAt(34, 2);
}

pub fn unknown5(self: @This()) bool {
    return self.row.bitAt(34, 3);
}

pub fn canStatusOff(self: @This()) bool {
    return self.row.bitAt(34, 4);
}

pub fn isFcBuff(self: @This()) bool {
    return self.row.bitAt(34, 5);
}

pub fn invisibility(self: @This()) bool {
    return self.row.bitAt(34, 6);
}

pub fn unknown6(self: @This()) bool {
    return self.row.bitAt(34, 7);
}

pub fn unknown_70_2(self: @This()) bool {
    return self.row.bitAt(35, 0);
}

pub fn unknown7(self: @This()) bool {
    return self.row.bitAt(35, 1);
}
