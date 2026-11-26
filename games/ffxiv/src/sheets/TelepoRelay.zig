//! `TelepoRelay`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TelepoRelay = @This();

pub const sheet_name = "TelepoRelay";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x90abb4f4;
pub const Sheet = excel.Typed(TelepoRelay);

row: excel.Row,

pub const relays_len = 9;
pub fn relays(self: @This(), n0: usize) RelaysEntry {
    std.debug.assert(n0 < 9);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const RelaysEntry = struct {
    row: excel.Row,
    at: [1]u16,

    /// Links to `TerritoryType`.
    pub fn enterTerritory(self: @This()) excel.Link(sheets.TerritoryType) {
        return .of(self.row.at(u16, offsets_1[self.at[0]]));
    }

    /// Links to `TerritoryType`.
    pub fn exitTerritory(self: @This()) excel.Link(sheets.TerritoryType) {
        return .of(self.row.at(u16, offsets_2[self.at[0]]));
    }

    pub fn cost(self: @This()) u16 {
        return self.row.at(u16, offsets_3[self.at[0]]);
    }
};

pub fn unknown_70(self: @This()) u32 {
    return self.row.at(u32, 56);
}

const offsets_1 = [9]u16{ 0, 6, 12, 18, 24, 30, 36, 42, 48 };
const offsets_2 = [9]u16{ 2, 8, 14, 20, 26, 32, 38, 44, 50 };
const offsets_3 = [9]u16{ 4, 10, 16, 22, 28, 34, 40, 46, 52 };
