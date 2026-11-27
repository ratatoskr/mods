//! `DynamicEvent`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DynamicEvent = @This();

pub const sheet_name = "DynamicEvent";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe78fd2e5;
pub const Sheet = excel.Typed(DynamicEvent);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "EventType", "EnemyType", "MaxParticipants", "Duration", "Unknown8", "LGBEventObject", "LGBMapRange", "Quest", "Unknown5", "SingleBattle", "Announce", "Name", "Description", "Unknown6", "Unknown7", "Unknown2", "IconObjective0", "IconObjective1", "Unknown9" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn lgbEventObject(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn lgbMapRange(self: @This()) u32 {
    return self.row.at(u32, 12);
}

/// Links to `Quest`.
pub fn quest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 16));
}

/// Links to `LogMessage`.
pub fn announce(self: @This()) excel.Link(sheets.LogMessage) {
    return .of(self.row.at(u32, 20));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn iconObjective0(self: @This()) u32 {
    return self.row.at(u32, 24);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn iconObjective1(self: @This()) u32 {
    return self.row.at(u32, 28);
}

pub fn unknown6(self: @This()) i16 {
    return self.row.at(i16, 32);
}

pub fn unknown7(self: @This()) i16 {
    return self.row.at(i16, 34);
}

pub fn unknown2(self: @This()) i16 {
    return self.row.at(i16, 36);
}

/// Links to `DynamicEventType`.
pub fn eventType(self: @This()) excel.Link(sheets.DynamicEventType) {
    return .of(self.row.at(u8, 38));
}

/// Links to `DynamicEventEnemyType`.
pub fn enemyType(self: @This()) excel.Link(sheets.DynamicEventEnemyType) {
    return .of(self.row.at(u8, 39));
}

pub fn maxParticipants(self: @This()) u8 {
    return self.row.at(u8, 40);
}

/// In minutes.
pub fn duration(self: @This()) u8 {
    return self.row.at(u8, 41);
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 42);
}

/// Links to `DynamicEventSingleBattle`.
pub fn singleBattle(self: @This()) excel.Link(sheets.DynamicEventSingleBattle) {
    return .of(self.row.at(u8, 43));
}

pub fn unknown9(self: @This()) u8 {
    return self.row.at(u8, 44);
}

pub fn unknown8(self: @This()) bool {
    return self.row.bitAt(45, 0);
}
