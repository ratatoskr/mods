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

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "Quest", "Variables[0].Name", "Variables[1].Name", "Variables[2].Name", "Variables[3].Name", "Variables[4].Name", "Variables[5].Name", "Variables[6].Name", "Variables[7].Name", "Variables[8].Name", "Variables[9].Name", "Variables[10].Name", "Variables[11].Name", "Variables[12].Name", "Variables[13].Name", "Variables[14].Name", "Variables[15].Name", "Variables[16].Name", "Variables[17].Name", "Variables[18].Name", "Variables[19].Name", "Variables[20].Name", "Variables[21].Name", "Variables[22].Name", "Variables[23].Name", "Variables[24].Name", "Variables[25].Name", "Variables[26].Name", "Variables[27].Name", "Variables[28].Name", "Variables[29].Name", "Variables[30].Name", "Variables[31].Name", "Variables[32].Name", "Variables[33].Name", "Variables[34].Name", "Variables[35].Name", "Variables[36].Name", "Variables[37].Name", "Variables[38].Name", "Variables[39].Name", "Variables[0].Value", "Variables[1].Value", "Variables[2].Value", "Variables[3].Value", "Variables[4].Value", "Variables[5].Value", "Variables[6].Value", "Variables[7].Value", "Variables[8].Value", "Variables[9].Value", "Variables[10].Value", "Variables[11].Value", "Variables[12].Value", "Variables[13].Value", "Variables[14].Value", "Variables[15].Value", "Variables[16].Value", "Variables[17].Value", "Variables[18].Value", "Variables[19].Value", "Variables[20].Value", "Variables[21].Value", "Variables[22].Value", "Variables[23].Value", "Variables[24].Value", "Variables[25].Value", "Variables[26].Value", "Variables[27].Value", "Variables[28].Value", "Variables[29].Value", "Variables[30].Value", "Variables[31].Value", "Variables[32].Value", "Variables[33].Value", "Variables[34].Value", "Variables[35].Value", "Variables[36].Value", "Variables[37].Value", "Variables[38].Value", "Variables[39].Value" };

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
