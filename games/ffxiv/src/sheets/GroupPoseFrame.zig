//! `GroupPoseFrame`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Text`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GroupPoseFrame = @This();

pub const sheet_name = "GroupPoseFrame";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf171642a;
pub const Sheet = excel.Typed(GroupPoseFrame);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown1", "Image", "GridText", "Unknown2", "Unknown0", "SortKey", "UnlockType", "UnlockCriteria", "Festival", "Text" };

pub fn text(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn gridText(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 8);
}

/// Links by `UnlockType`: 1 to `Quest`, 3 to `InstanceContent`, 4 to `InstanceContent`, 5 to `Emote`, 6 to `Companion`, 7 to `Mount`, 8 to `Ornament`.
pub fn unlockCriteria(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn unknown1(self: @This()) i32 {
    return self.row.at(i32, 16);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn image(self: @This()) i32 {
    return self.row.at(i32, 20);
}

pub fn unknown2(self: @This()) i32 {
    return self.row.at(i32, 24);
}

/// Links to `Festival`.
pub fn festival(self: @This()) excel.Link(sheets.Festival) {
    return .of(self.row.at(i32, 28));
}

pub fn sortKey(self: @This()) u8 {
    return self.row.at(u8, 32);
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
    return self.row.at(u8, 33);
}
