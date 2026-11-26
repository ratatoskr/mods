//! `FateEvent`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const FateEvent = @This();

pub const sheet_name = "FateEvent";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x0f779649;
pub const Sheet = excel.Typed(FateEvent);

row: excel.Row,

pub const event_parameters_len = 8;
pub fn eventParameters(self: @This(), n0: usize) EventParametersEntry {
    std.debug.assert(n0 < 8);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const EventParametersEntry = struct {
    row: excel.Row,
    at: [1]u16,

    pub fn gesture(self: @This()) u32 {
        return self.row.at(u32, offsets_1[self.at[0]]);
    }

    pub fn lipSync(self: @This()) i32 {
        return self.row.at(i32, offsets_2[self.at[0]]);
    }

    pub fn facial(self: @This()) i32 {
        return self.row.at(i32, offsets_3[self.at[0]]);
    }

    pub fn shape(self: @This()) i32 {
        return self.row.at(i32, offsets_4[self.at[0]]);
    }

    pub fn turn(self: @This()) u8 {
        return self.row.at(u8, offsets_5[self.at[0]]);
    }

    pub fn widgetType(self: @This()) u8 {
        return self.row.at(u8, offsets_6[self.at[0]]);
    }

    pub fn isAutoShake(self: @This()) bool {
        return self.row.bitAt(@intCast(offsets_7[self.at[0]] >> 3), @intCast(offsets_7[self.at[0]] & 7));
    }
};

pub const text_len = 8;
pub fn text(self: @This(), n0: usize) []const u8 {
    return self.row.stringAt(offsets_8[n0]);
}

const offsets_1 = [8]u16{ 0, 20, 40, 60, 80, 100, 120, 140 };
const offsets_2 = [8]u16{ 4, 24, 44, 64, 84, 104, 124, 144 };
const offsets_3 = [8]u16{ 8, 28, 48, 68, 88, 108, 128, 148 };
const offsets_4 = [8]u16{ 12, 32, 52, 72, 92, 112, 132, 152 };
const offsets_5 = [8]u16{ 16, 36, 56, 76, 96, 116, 136, 156 };
const offsets_6 = [8]u16{ 17, 37, 57, 77, 97, 117, 137, 157 };
const offsets_7 = [8]u32{ 144, 304, 464, 624, 784, 944, 1104, 1264 };
const offsets_8 = [8]u16{ 160, 164, 168, 172, 176, 180, 184, 188 };
