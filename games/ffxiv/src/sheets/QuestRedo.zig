//! `QuestRedo`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `FinalQuest`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const QuestRedo = @This();

pub const sheet_name = "QuestRedo";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x9e53f329;
pub const Sheet = excel.Typed(QuestRedo);

row: excel.Row,

pub const quest_redo_param_len = 32;
pub fn questRedoParam(self: @This(), n0: usize) QuestRedoParamEntry {
    std.debug.assert(n0 < 32);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const QuestRedoParamEntry = struct {
    row: excel.Row,
    at: [1]u16,

    /// Links to `Quest`.
    pub fn quest(self: @This()) excel.Link(sheets.Quest) {
        return .of(self.row.at(u32, offsets_1[self.at[0]]));
    }

    pub fn unknownParam(self: @This()) u8 {
        return self.row.at(u8, offsets_2[self.at[0]]);
    }
};

/// Links to `Quest`.
pub fn finalQuest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 256));
}

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 260);
}

/// Links to `QuestRedoChapter`.
pub fn chapter(self: @This()) excel.Link(sheets.QuestRedoChapter) {
    return .of(self.row.at(u16, 264));
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 266);
}

const offsets_1 = [32]u16{ 0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120, 128, 136, 144, 152, 160, 168, 176, 184, 192, 200, 208, 216, 224, 232, 240, 248 };
const offsets_2 = [32]u16{ 4, 12, 20, 28, 36, 44, 52, 60, 68, 76, 84, 92, 100, 108, 116, 124, 132, 140, 148, 156, 164, 172, 180, 188, 196, 204, 212, 220, 228, 236, 244, 252 };
