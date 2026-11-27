//! `EmoteMode`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `StartEmote`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EmoteMode = @This();

pub const sheet_name = "EmoteMode";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x087a32e7;
pub const Sheet = excel.Typed(EmoteMode);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "StartEmote", "EndEmote", "Move", "Camera", "EndOnRotate", "EndOnEmote", "ConditionMode", "Unknown0" };

/// Links to `Emote`.
pub fn startEmote(self: @This()) excel.Link(sheets.Emote) {
    return .of(self.row.at(u16, 0));
}

/// Links to `Emote`.
pub fn endEmote(self: @This()) excel.Link(sheets.Emote) {
    return .of(self.row.at(u16, 2));
}

pub fn conditionMode(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn move(self: @This()) bool {
    return self.row.bitAt(5, 0);
}

pub fn camera(self: @This()) bool {
    return self.row.bitAt(5, 1);
}

pub fn endOnRotate(self: @This()) bool {
    return self.row.bitAt(5, 2);
}

pub fn endOnEmote(self: @This()) bool {
    return self.row.bitAt(5, 3);
}

pub fn unknown0(self: @This()) bool {
    return self.row.bitAt(5, 4);
}
