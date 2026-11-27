//! `MJICraftworksPopularity`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJICraftworksPopularity = @This();

pub const sheet_name = "MJICraftworksPopularity";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x92a82168;
pub const Sheet = excel.Typed(MJICraftworksPopularity);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Popularity[0]", "Popularity[1]", "Popularity[2]", "Popularity[3]", "Popularity[4]", "Popularity[5]", "Popularity[6]", "Popularity[7]", "Popularity[8]", "Popularity[9]", "Popularity[10]", "Popularity[11]", "Popularity[12]", "Popularity[13]", "Popularity[14]", "Popularity[15]", "Popularity[16]", "Popularity[17]", "Popularity[18]", "Popularity[19]", "Popularity[20]", "Popularity[21]", "Popularity[22]", "Popularity[23]", "Popularity[24]", "Popularity[25]", "Popularity[26]", "Popularity[27]", "Popularity[28]", "Popularity[29]", "Popularity[30]", "Popularity[31]", "Popularity[32]", "Popularity[33]", "Popularity[34]", "Popularity[35]", "Popularity[36]", "Popularity[37]", "Popularity[38]", "Popularity[39]", "Popularity[40]", "Popularity[41]", "Popularity[42]", "Popularity[43]", "Popularity[44]", "Popularity[45]", "Popularity[46]", "Popularity[47]", "Popularity[48]", "Popularity[49]", "Popularity[50]", "Popularity[51]", "Popularity[52]", "Popularity[53]", "Popularity[54]", "Popularity[55]", "Popularity[56]", "Popularity[57]", "Popularity[58]", "Popularity[59]", "Popularity[60]", "Popularity[61]", "Popularity[62]", "Popularity[63]", "Popularity[64]", "Popularity[65]", "Popularity[66]", "Popularity[67]", "Popularity[68]", "Popularity[69]", "Popularity[70]", "Popularity[71]", "Popularity[72]", "Popularity[73]", "Popularity[74]", "Popularity[75]", "Popularity[76]", "Popularity[77]", "Popularity[78]", "Popularity[79]", "Popularity[80]", "Popularity[81]", "Popularity[82]", "Popularity[83]", "Popularity[84]", "Popularity[85]", "Popularity[86]", "Popularity[87]", "Popularity[88]", "Popularity[89]", "Popularity[90]" };

pub const popularity_len = 91;
/// Links to `MJICraftworksPopularityType`.
pub fn popularity(self: @This(), n0: usize) excel.Link(sheets.MJICraftworksPopularityType) {
    return .of(self.row.at(u8, offsets_1[n0]));
}

const offsets_1 = [91]u16{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90 };
