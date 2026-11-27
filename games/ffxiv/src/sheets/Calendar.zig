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

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "CalendarStruct[0].Month", "CalendarStruct[1].Month", "CalendarStruct[2].Month", "CalendarStruct[3].Month", "CalendarStruct[4].Month", "CalendarStruct[5].Month", "CalendarStruct[6].Month", "CalendarStruct[7].Month", "CalendarStruct[8].Month", "CalendarStruct[9].Month", "CalendarStruct[10].Month", "CalendarStruct[11].Month", "CalendarStruct[12].Month", "CalendarStruct[13].Month", "CalendarStruct[14].Month", "CalendarStruct[15].Month", "CalendarStruct[16].Month", "CalendarStruct[17].Month", "CalendarStruct[18].Month", "CalendarStruct[19].Month", "CalendarStruct[20].Month", "CalendarStruct[21].Month", "CalendarStruct[22].Month", "CalendarStruct[23].Month", "CalendarStruct[24].Month", "CalendarStruct[25].Month", "CalendarStruct[26].Month", "CalendarStruct[27].Month", "CalendarStruct[28].Month", "CalendarStruct[29].Month", "CalendarStruct[30].Month", "CalendarStruct[31].Month", "CalendarStruct[0].Day", "CalendarStruct[1].Day", "CalendarStruct[2].Day", "CalendarStruct[3].Day", "CalendarStruct[4].Day", "CalendarStruct[5].Day", "CalendarStruct[6].Day", "CalendarStruct[7].Day", "CalendarStruct[8].Day", "CalendarStruct[9].Day", "CalendarStruct[10].Day", "CalendarStruct[11].Day", "CalendarStruct[12].Day", "CalendarStruct[13].Day", "CalendarStruct[14].Day", "CalendarStruct[15].Day", "CalendarStruct[16].Day", "CalendarStruct[17].Day", "CalendarStruct[18].Day", "CalendarStruct[19].Day", "CalendarStruct[20].Day", "CalendarStruct[21].Day", "CalendarStruct[22].Day", "CalendarStruct[23].Day", "CalendarStruct[24].Day", "CalendarStruct[25].Day", "CalendarStruct[26].Day", "CalendarStruct[27].Day", "CalendarStruct[28].Day", "CalendarStruct[29].Day", "CalendarStruct[30].Day", "CalendarStruct[31].Day" };

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
