//! `GroupPoseStamp`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GroupPoseStamp = @This();

pub const sheet_name = "GroupPoseStamp";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x65a8a2df;
pub const Sheet = excel.Typed(GroupPoseStamp);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links by `UnlockType`: 1 to `Quest`, 3 to `InstanceContent`, 4 to `InstanceContent`, 5 to `Emote`, 6 to `Companion`, 7 to `Mount`, 8 to `Ornament`.
pub fn unlockCriteria(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn stampIcon(self: @This()) i32 {
    return self.row.at(i32, 8);
}

pub fn unknown1(self: @This()) i32 {
    return self.row.at(i32, 12);
}

/// Links to `GroupPoseStampCategory`.
pub fn category(self: @This()) excel.Link(sheets.GroupPoseStampCategory) {
    return .of(self.row.at(i32, 16));
}

/// Links to `Festival`.
pub fn festival(self: @This()) excel.Link(sheets.Festival) {
    return .of(self.row.at(i32, 20));
}

pub fn sortKey(self: @This()) u16 {
    return self.row.at(u16, 24);
}

/// 1 = Quest
/// 2 = UnlockLink
/// 3 = InstanceContent unlocked
/// 4 = InstanceContent completed
/// 5 = Emote unlocked
/// 6 = Companion unlocked
/// 7 = Mount unlocked
/// 8 = Ornament unlocked
/// 9 = FramersKit unlocked
/// 10 = Always available
pub fn unlockType(self: @This()) u8 {
    return self.row.at(u8, 26);
}

pub fn unknown5(self: @This()) bool {
    return self.row.bitAt(27, 0);
}

pub fn unknown6(self: @This()) bool {
    return self.row.bitAt(27, 1);
}

pub fn unknown7(self: @This()) bool {
    return self.row.bitAt(27, 2);
}
