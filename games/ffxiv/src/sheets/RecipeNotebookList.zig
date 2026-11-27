//! `RecipeNotebookList`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const RecipeNotebookList = @This();

pub const sheet_name = "RecipeNotebookList";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xa067051f;
pub const Sheet = excel.Typed(RecipeNotebookList);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Count", "Recipe[0]", "Recipe[1]", "Recipe[2]", "Recipe[3]", "Recipe[4]", "Recipe[5]", "Recipe[6]", "Recipe[7]", "Recipe[8]", "Recipe[9]", "Recipe[10]", "Recipe[11]", "Recipe[12]", "Recipe[13]", "Recipe[14]", "Recipe[15]", "Recipe[16]", "Recipe[17]", "Recipe[18]", "Recipe[19]", "Recipe[20]", "Recipe[21]", "Recipe[22]", "Recipe[23]", "Recipe[24]", "Recipe[25]", "Recipe[26]", "Recipe[27]", "Recipe[28]", "Recipe[29]", "Recipe[30]", "Recipe[31]", "Recipe[32]", "Recipe[33]", "Recipe[34]", "Recipe[35]", "Recipe[36]", "Recipe[37]", "Recipe[38]", "Recipe[39]", "Recipe[40]", "Recipe[41]", "Recipe[42]", "Recipe[43]", "Recipe[44]", "Recipe[45]", "Recipe[46]", "Recipe[47]", "Recipe[48]", "Recipe[49]", "Recipe[50]", "Recipe[51]", "Recipe[52]", "Recipe[53]", "Recipe[54]", "Recipe[55]", "Recipe[56]", "Recipe[57]", "Recipe[58]", "Recipe[59]", "Recipe[60]", "Recipe[61]", "Recipe[62]", "Recipe[63]", "Recipe[64]", "Recipe[65]", "Recipe[66]", "Recipe[67]", "Recipe[68]", "Recipe[69]", "Recipe[70]", "Recipe[71]", "Recipe[72]", "Recipe[73]", "Recipe[74]", "Recipe[75]", "Recipe[76]", "Recipe[77]", "Recipe[78]", "Recipe[79]", "Recipe[80]", "Recipe[81]", "Recipe[82]", "Recipe[83]", "Recipe[84]", "Recipe[85]", "Recipe[86]", "Recipe[87]", "Recipe[88]", "Recipe[89]", "Recipe[90]", "Recipe[91]", "Recipe[92]", "Recipe[93]", "Recipe[94]", "Recipe[95]", "Recipe[96]", "Recipe[97]", "Recipe[98]", "Recipe[99]", "Recipe[100]", "Recipe[101]", "Recipe[102]", "Recipe[103]", "Recipe[104]", "Recipe[105]", "Recipe[106]", "Recipe[107]", "Recipe[108]", "Recipe[109]", "Recipe[110]", "Recipe[111]", "Recipe[112]", "Recipe[113]", "Recipe[114]", "Recipe[115]", "Recipe[116]", "Recipe[117]", "Recipe[118]", "Recipe[119]", "Recipe[120]", "Recipe[121]", "Recipe[122]", "Recipe[123]", "Recipe[124]", "Recipe[125]", "Recipe[126]", "Recipe[127]", "Recipe[128]", "Recipe[129]", "Recipe[130]", "Recipe[131]", "Recipe[132]", "Recipe[133]", "Recipe[134]", "Recipe[135]", "Recipe[136]", "Recipe[137]", "Recipe[138]", "Recipe[139]", "Recipe[140]", "Recipe[141]", "Recipe[142]", "Recipe[143]", "Recipe[144]", "Recipe[145]", "Recipe[146]", "Recipe[147]", "Recipe[148]", "Recipe[149]", "Recipe[150]", "Recipe[151]", "Recipe[152]", "Recipe[153]", "Recipe[154]", "Recipe[155]", "Recipe[156]", "Recipe[157]", "Recipe[158]", "Recipe[159]" };

pub const recipe_len = 160;
/// Links to `Recipe`.
pub fn recipe(self: @This(), n0: usize) excel.Link(sheets.Recipe) {
    return .of(self.row.at(i32, offsets_1[n0]));
}

pub fn count(self: @This()) u8 {
    return self.row.at(u8, 640);
}

const offsets_1 = [160]u16{ 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 68, 72, 76, 80, 84, 88, 92, 96, 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140, 144, 148, 152, 156, 160, 164, 168, 172, 176, 180, 184, 188, 192, 196, 200, 204, 208, 212, 216, 220, 224, 228, 232, 236, 240, 244, 248, 252, 256, 260, 264, 268, 272, 276, 280, 284, 288, 292, 296, 300, 304, 308, 312, 316, 320, 324, 328, 332, 336, 340, 344, 348, 352, 356, 360, 364, 368, 372, 376, 380, 384, 388, 392, 396, 400, 404, 408, 412, 416, 420, 424, 428, 432, 436, 440, 444, 448, 452, 456, 460, 464, 468, 472, 476, 480, 484, 488, 492, 496, 500, 504, 508, 512, 516, 520, 524, 528, 532, 536, 540, 544, 548, 552, 556, 560, 564, 568, 572, 576, 580, 584, 588, 592, 596, 600, 604, 608, 612, 616, 620, 624, 628, 632, 636 };
