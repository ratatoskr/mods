//! `Opening`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Opening = @This();

pub const sheet_name = "Opening";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xfe684a57;
pub const Sheet = excel.Typed(Opening);

row: excel.Row,

pub const variables_len = 40;
pub fn variables(self: @This(), n0: usize) VariablesEntry {
    std.debug.assert(n0 < 40);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const VariablesEntry = struct {
    row: excel.Row,
    at: [1]u16,

    pub fn name(self: @This()) []const u8 {
        return self.row.stringAt(offsets_1[self.at[0]]);
    }

    pub fn value(self: @This()) u32 {
        return self.row.at(u32, offsets_2[self.at[0]]);
    }
};

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(320);
}

/// Links to `Quest`.
pub fn quest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 324));
}

const offsets_1 = [40]u16{ 0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120, 128, 136, 144, 152, 160, 168, 176, 184, 192, 200, 208, 216, 224, 232, 240, 248, 256, 264, 272, 280, 288, 296, 304, 312 };
const offsets_2 = [40]u16{ 4, 12, 20, 28, 36, 44, 52, 60, 68, 76, 84, 92, 100, 108, 116, 124, 132, 140, 148, 156, 164, 172, 180, 188, 196, 204, 212, 220, 228, 236, 244, 252, 260, 268, 276, 284, 292, 300, 308, 316 };
