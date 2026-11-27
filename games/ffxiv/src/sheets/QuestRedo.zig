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

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "FinalQuest", "Unknown0", "Unknown1", "Chapter", "QuestRedoParam[0].Quest", "QuestRedoParam[1].Quest", "QuestRedoParam[2].Quest", "QuestRedoParam[3].Quest", "QuestRedoParam[4].Quest", "QuestRedoParam[5].Quest", "QuestRedoParam[6].Quest", "QuestRedoParam[7].Quest", "QuestRedoParam[8].Quest", "QuestRedoParam[9].Quest", "QuestRedoParam[10].Quest", "QuestRedoParam[11].Quest", "QuestRedoParam[12].Quest", "QuestRedoParam[13].Quest", "QuestRedoParam[14].Quest", "QuestRedoParam[15].Quest", "QuestRedoParam[16].Quest", "QuestRedoParam[17].Quest", "QuestRedoParam[18].Quest", "QuestRedoParam[19].Quest", "QuestRedoParam[20].Quest", "QuestRedoParam[21].Quest", "QuestRedoParam[22].Quest", "QuestRedoParam[23].Quest", "QuestRedoParam[24].Quest", "QuestRedoParam[25].Quest", "QuestRedoParam[26].Quest", "QuestRedoParam[27].Quest", "QuestRedoParam[28].Quest", "QuestRedoParam[29].Quest", "QuestRedoParam[30].Quest", "QuestRedoParam[31].Quest", "QuestRedoParam[0].UnknownParam", "QuestRedoParam[1].UnknownParam", "QuestRedoParam[2].UnknownParam", "QuestRedoParam[3].UnknownParam", "QuestRedoParam[4].UnknownParam", "QuestRedoParam[5].UnknownParam", "QuestRedoParam[6].UnknownParam", "QuestRedoParam[7].UnknownParam", "QuestRedoParam[8].UnknownParam", "QuestRedoParam[9].UnknownParam", "QuestRedoParam[10].UnknownParam", "QuestRedoParam[11].UnknownParam", "QuestRedoParam[12].UnknownParam", "QuestRedoParam[13].UnknownParam", "QuestRedoParam[14].UnknownParam", "QuestRedoParam[15].UnknownParam", "QuestRedoParam[16].UnknownParam", "QuestRedoParam[17].UnknownParam", "QuestRedoParam[18].UnknownParam", "QuestRedoParam[19].UnknownParam", "QuestRedoParam[20].UnknownParam", "QuestRedoParam[21].UnknownParam", "QuestRedoParam[22].UnknownParam", "QuestRedoParam[23].UnknownParam", "QuestRedoParam[24].UnknownParam", "QuestRedoParam[25].UnknownParam", "QuestRedoParam[26].UnknownParam", "QuestRedoParam[27].UnknownParam", "QuestRedoParam[28].UnknownParam", "QuestRedoParam[29].UnknownParam", "QuestRedoParam[30].UnknownParam", "QuestRedoParam[31].UnknownParam" };

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
