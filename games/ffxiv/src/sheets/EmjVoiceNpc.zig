//! `EmjVoiceNpc`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EmjVoiceNpc = @This();

pub const sheet_name = "EmjVoiceNpc";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xaa50be21;
pub const Sheet = excel.Typed(EmjVoiceNpc);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "UnlockLink", "EmjCostume", "VoLines[0]", "VoLines[1]", "VoLines[2]", "VoLines[3]", "VoLines[4]", "VoLines[5]", "VoLines[6]", "VoLines[7]", "VoLines[8]", "VoLines[9]", "VoLines[10]", "VoLines[11]", "VoLines[12]", "VoLines[13]", "VoLines[14]", "VoLines[15]", "VoLines[16]", "VoLines[17]", "VoLines[18]", "VoLines[19]", "VoLines[20]", "VoLines[21]", "VoLines[22]", "VoLines[23]", "VoLines[24]", "Name", "NameJapanese", "Unknown0" };

pub const vo_lines_len = 25;
pub fn voLines(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_1[n0]);
}

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(100);
}

pub fn nameJapanese(self: @This()) []const u8 {
    return self.row.stringAt(104);
}

pub fn unlockLink(self: @This()) u16 {
    return self.row.at(u16, 108);
}

pub fn emjCostume(self: @This()) u16 {
    return self.row.at(u16, 110);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 112);
}

const offsets_1 = [25]u16{ 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 68, 72, 76, 80, 84, 88, 92, 96 };
