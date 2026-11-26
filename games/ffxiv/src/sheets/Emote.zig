//! `Emote`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Emote = @This();

pub const sheet_name = "Emote";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xaff5d14e;
pub const Sheet = excel.Typed(Emote);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unlockLink(self: @This()) u32 {
    return self.row.at(u32, 8);
}

/// Links to `TextCommand`.
pub fn textCommand(self: @This()) excel.Link(sheets.TextCommand) {
    return .of(self.row.at(i32, 12));
}

pub const action_timeline_len = 7;
/// 0 = Standing
/// 1 = Start animation
/// 2 = Ground sit
/// 3 = Chair sit
/// 4 = Mounted / Swimming / Diving
/// 5 = Dozing
/// 6 = Unused
/// Links to `ActionTimeline`.
pub fn actionTimeline(self: @This(), n0: usize) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

pub fn order(self: @This()) u16 {
    return self.row.at(u16, 30);
}

/// Links to `LogMessage`.
pub fn logMessageTargeted(self: @This()) excel.Link(sheets.LogMessage) {
    return .of(self.row.at(u16, 32));
}

/// Links to `LogMessage`.
pub fn logMessageUntargeted(self: @This()) excel.Link(sheets.LogMessage) {
    return .of(self.row.at(u16, 34));
}

pub fn patch(self: @This()) u16 {
    return self.row.at(u16, 36);
}

/// 3 (Expressions) = Usable everywhere (other columns are overridden)
/// Links to `EmoteCategory`.
pub fn emoteCategory(self: @This()) excel.Link(sheets.EmoteCategory) {
    return .of(self.row.at(u8, 38));
}

/// Links to `EmoteMode`.
pub fn emoteMode(self: @This()) excel.Link(sheets.EmoteMode) {
    return .of(self.row.at(u8, 39));
}

pub fn usableWhenMounted(self: @This()) bool {
    return self.row.bitAt(40, 0);
}

pub fn usableWhenSwimming(self: @This()) bool {
    return self.row.bitAt(40, 1);
}

pub fn usableWhenDiving(self: @This()) bool {
    return self.row.bitAt(40, 2);
}

pub fn dontSetEmoteMode(self: @This()) bool {
    return self.row.bitAt(40, 3);
}

/// Maybe controls whether or not the emote can be synced in GPose?!
pub fn unknown5(self: @This()) bool {
    return self.row.bitAt(40, 4);
}

pub fn usableWhenFishing(self: @This()) bool {
    return self.row.bitAt(40, 5);
}

pub fn drawsWeapon(self: @This()) bool {
    return self.row.bitAt(40, 6);
}

pub fn sheathesWeapon(self: @This()) bool {
    return self.row.bitAt(40, 7);
}

const offsets_1 = [7]u16{ 16, 18, 20, 22, 24, 26, 28 };
