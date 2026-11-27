//! `GatheringNotebookList`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GatheringNotebookList = @This();

pub const sheet_name = "GatheringNotebookList";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x1da7bb26;
pub const Sheet = excel.Typed(GatheringNotebookList);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "GatheringItem[0]", "GatheringItem[1]", "GatheringItem[2]", "GatheringItem[3]", "GatheringItem[4]", "GatheringItem[5]", "GatheringItem[6]", "GatheringItem[7]", "GatheringItem[8]", "GatheringItem[9]", "GatheringItem[10]", "GatheringItem[11]", "GatheringItem[12]", "GatheringItem[13]", "GatheringItem[14]", "GatheringItem[15]", "GatheringItem[16]", "GatheringItem[17]", "GatheringItem[18]", "GatheringItem[19]", "GatheringItem[20]", "GatheringItem[21]", "GatheringItem[22]", "GatheringItem[23]", "GatheringItem[24]", "GatheringItem[25]", "GatheringItem[26]", "GatheringItem[27]", "GatheringItem[28]", "GatheringItem[29]", "GatheringItem[30]", "GatheringItem[31]", "GatheringItem[32]", "GatheringItem[33]", "GatheringItem[34]", "GatheringItem[35]", "GatheringItem[36]", "GatheringItem[37]", "GatheringItem[38]", "GatheringItem[39]", "GatheringItem[40]", "GatheringItem[41]", "GatheringItem[42]", "GatheringItem[43]", "GatheringItem[44]", "GatheringItem[45]", "GatheringItem[46]", "GatheringItem[47]", "GatheringItem[48]", "GatheringItem[49]", "GatheringItem[50]", "GatheringItem[51]", "GatheringItem[52]", "GatheringItem[53]", "GatheringItem[54]", "GatheringItem[55]", "GatheringItem[56]", "GatheringItem[57]", "GatheringItem[58]", "GatheringItem[59]", "GatheringItem[60]", "GatheringItem[61]", "GatheringItem[62]", "GatheringItem[63]", "GatheringItem[64]", "GatheringItem[65]", "GatheringItem[66]", "GatheringItem[67]", "GatheringItem[68]", "GatheringItem[69]", "GatheringItem[70]", "GatheringItem[71]", "GatheringItem[72]", "GatheringItem[73]", "GatheringItem[74]", "GatheringItem[75]", "GatheringItem[76]", "GatheringItem[77]", "GatheringItem[78]", "GatheringItem[79]", "GatheringItem[80]", "GatheringItem[81]", "GatheringItem[82]", "GatheringItem[83]", "GatheringItem[84]", "GatheringItem[85]", "GatheringItem[86]", "GatheringItem[87]", "GatheringItem[88]", "GatheringItem[89]", "GatheringItem[90]", "GatheringItem[91]", "GatheringItem[92]", "GatheringItem[93]", "GatheringItem[94]", "GatheringItem[95]", "GatheringItem[96]", "GatheringItem[97]", "GatheringItem[98]", "GatheringItem[99]" };

pub const gathering_item_len = 100;
/// Links to `GatheringItem`.
pub fn gatheringItem(self: @This(), n0: usize) excel.Link(sheets.GatheringItem) {
    return .of(self.row.at(i32, offsets_1[n0]));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 400);
}

const offsets_1 = [100]u16{ 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 68, 72, 76, 80, 84, 88, 92, 96, 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140, 144, 148, 152, 156, 160, 164, 168, 172, 176, 180, 184, 188, 192, 196, 200, 204, 208, 212, 216, 220, 224, 228, 232, 236, 240, 244, 248, 252, 256, 260, 264, 268, 272, 276, 280, 284, 288, 292, 296, 300, 304, 308, 312, 316, 320, 324, 328, 332, 336, 340, 344, 348, 352, 356, 360, 364, 368, 372, 376, 380, 384, 388, 392, 396 };
