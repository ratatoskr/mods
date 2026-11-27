//! `ActionTimeline`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Key`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ActionTimeline = @This();

pub const sheet_name = "ActionTimeline";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd803699f;
pub const Sheet = excel.Typed(ActionTimeline);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown_70", "Type", "Pause", "Priority", "Stance", "Slot", "Key", "LookAtMode", "WeaponTimeline", "ActionTimelineIDMode", "LoadType", "StartAttach", "KillUpper", "Resident", "IsMotionCanceledByMoving", "ResidentPap", "Unknown2", "Unknown3", "IsLoop", "Unknown6", "Unknown1", "Unknown4" };

pub fn key(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `WeaponTimeline`.
pub fn weaponTimeline(self: @This()) excel.Link(sheets.WeaponTimeline) {
    return .of(self.row.at(u16, 4));
}

pub fn killUpper(self: @This()) u16 {
    return self.row.at(u16, 6);
}

pub fn unknown_70(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn @"type"(self: @This()) u8 {
    return self.row.at(u8, 9);
}

pub fn priority(self: @This()) u8 {
    return self.row.at(u8, 10);
}

pub fn stance(self: @This()) u8 {
    return self.row.at(u8, 11);
}

pub fn slot(self: @This()) u8 {
    return self.row.at(u8, 12);
}

pub fn lookAtMode(self: @This()) u8 {
    return self.row.at(u8, 13);
}

pub fn actionTimelineIDMode(self: @This()) u8 {
    return self.row.at(u8, 14);
}

pub fn loadType(self: @This()) u8 {
    return self.row.at(u8, 15);
}

pub fn startAttach(self: @This()) u8 {
    return self.row.at(u8, 16);
}

pub fn residentPap(self: @This()) u8 {
    return self.row.at(u8, 17);
}

pub fn unknown6(self: @This()) u8 {
    return self.row.at(u8, 18);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 19);
}

pub fn pause(self: @This()) bool {
    return self.row.bitAt(20, 0);
}

pub fn resident(self: @This()) bool {
    return self.row.bitAt(20, 1);
}

pub fn isMotionCanceledByMoving(self: @This()) bool {
    return self.row.bitAt(20, 2);
}

pub fn unknown2(self: @This()) bool {
    return self.row.bitAt(20, 3);
}

pub fn unknown3(self: @This()) bool {
    return self.row.bitAt(20, 4);
}

pub fn isLoop(self: @This()) bool {
    return self.row.bitAt(20, 5);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(20, 6);
}
