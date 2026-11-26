//! `Calendar`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Calendar = @This();

pub const sheet_name = "Calendar";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x005cfabb;
pub const Sheet = excel.Typed(Calendar);

row: excel.Row,

pub const calendar_struct_len = 32;
pub fn calendarStruct(self: @This(), n0: usize) CalendarStructEntry {
    std.debug.assert(n0 < 32);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const CalendarStructEntry = struct {
    row: excel.Row,
    at: [1]u16,

    pub fn month(self: @This()) u8 {
        return self.row.at(u8, offsets_1[self.at[0]]);
    }

    pub fn day(self: @This()) u8 {
        return self.row.at(u8, offsets_2[self.at[0]]);
    }
};

const offsets_1 = [32]u16{ 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62 };
const offsets_2 = [32]u16{ 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35, 37, 39, 41, 43, 45, 47, 49, 51, 53, 55, 57, 59, 61, 63 };
