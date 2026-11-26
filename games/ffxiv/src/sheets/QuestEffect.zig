//! `QuestEffect`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const QuestEffect = @This();

pub const sheet_name = "QuestEffect";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x899c55ad;
pub const Sheet = excel.Typed(QuestEffect);

row: excel.Row,

pub const effects_len = 4;
pub fn effects(self: @This(), n0: usize) EffectsEntry {
    std.debug.assert(n0 < 4);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const EffectsEntry = struct {
    row: excel.Row,
    at: [1]u16,

    pub fn param1(self: @This()) u32 {
        return self.row.at(u32, offsets_1[self.at[0]]);
    }

    pub fn param2(self: @This()) u32 {
        return self.row.at(u32, offsets_2[self.at[0]]);
    }

    pub fn @"type"(self: @This()) u8 {
        return self.row.at(u8, offsets_3[self.at[0]]);
    }
};

/// Links to `LogMessage`.
pub fn outOfRangeWarningMessage(self: @This()) excel.Link(sheets.LogMessage) {
    return .of(self.row.at(u32, 48));
}

/// Links to `LogMessage`.
pub fn outOfRangeMessage(self: @This()) excel.Link(sheets.LogMessage) {
    return .of(self.row.at(u32, 52));
}

pub fn unknown_70(self: @This()) bool {
    return self.row.bitAt(56, 0);
}

const offsets_1 = [4]u16{ 0, 12, 24, 36 };
const offsets_2 = [4]u16{ 4, 16, 28, 40 };
const offsets_3 = [4]u16{ 8, 20, 32, 44 };
