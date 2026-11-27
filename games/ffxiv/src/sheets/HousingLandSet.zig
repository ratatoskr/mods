//! `HousingLandSet`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HousingLandSet = @This();

pub const sheet_name = "HousingLandSet";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc557f79e;
pub const Sheet = excel.Typed(HousingLandSet);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "LandSet[0].PlotSize", "LandSet[1].PlotSize", "LandSet[2].PlotSize", "LandSet[3].PlotSize", "LandSet[4].PlotSize", "LandSet[5].PlotSize", "LandSet[6].PlotSize", "LandSet[7].PlotSize", "LandSet[8].PlotSize", "LandSet[9].PlotSize", "LandSet[10].PlotSize", "LandSet[11].PlotSize", "LandSet[12].PlotSize", "LandSet[13].PlotSize", "LandSet[14].PlotSize", "LandSet[15].PlotSize", "LandSet[16].PlotSize", "LandSet[17].PlotSize", "LandSet[18].PlotSize", "LandSet[19].PlotSize", "LandSet[20].PlotSize", "LandSet[21].PlotSize", "LandSet[22].PlotSize", "LandSet[23].PlotSize", "LandSet[24].PlotSize", "LandSet[25].PlotSize", "LandSet[26].PlotSize", "LandSet[27].PlotSize", "LandSet[28].PlotSize", "LandSet[29].PlotSize", "LandSet[30].PlotSize", "LandSet[31].PlotSize", "LandSet[32].PlotSize", "LandSet[33].PlotSize", "LandSet[34].PlotSize", "LandSet[35].PlotSize", "LandSet[36].PlotSize", "LandSet[37].PlotSize", "LandSet[38].PlotSize", "LandSet[39].PlotSize", "LandSet[40].PlotSize", "LandSet[41].PlotSize", "LandSet[42].PlotSize", "LandSet[43].PlotSize", "LandSet[44].PlotSize", "LandSet[45].PlotSize", "LandSet[46].PlotSize", "LandSet[47].PlotSize", "LandSet[48].PlotSize", "LandSet[49].PlotSize", "LandSet[50].PlotSize", "LandSet[51].PlotSize", "LandSet[52].PlotSize", "LandSet[53].PlotSize", "LandSet[54].PlotSize", "LandSet[55].PlotSize", "LandSet[56].PlotSize", "LandSet[57].PlotSize", "LandSet[58].PlotSize", "LandSet[59].PlotSize", "LandSet[0].MapRange", "LandSet[1].MapRange", "LandSet[2].MapRange", "LandSet[3].MapRange", "LandSet[4].MapRange", "LandSet[5].MapRange", "LandSet[6].MapRange", "LandSet[7].MapRange", "LandSet[8].MapRange", "LandSet[9].MapRange", "LandSet[10].MapRange", "LandSet[11].MapRange", "LandSet[12].MapRange", "LandSet[13].MapRange", "LandSet[14].MapRange", "LandSet[15].MapRange", "LandSet[16].MapRange", "LandSet[17].MapRange", "LandSet[18].MapRange", "LandSet[19].MapRange", "LandSet[20].MapRange", "LandSet[21].MapRange", "LandSet[22].MapRange", "LandSet[23].MapRange", "LandSet[24].MapRange", "LandSet[25].MapRange", "LandSet[26].MapRange", "LandSet[27].MapRange", "LandSet[28].MapRange", "LandSet[29].MapRange", "LandSet[30].MapRange", "LandSet[31].MapRange", "LandSet[32].MapRange", "LandSet[33].MapRange", "LandSet[34].MapRange", "LandSet[35].MapRange", "LandSet[36].MapRange", "LandSet[37].MapRange", "LandSet[38].MapRange", "LandSet[39].MapRange", "LandSet[40].MapRange", "LandSet[41].MapRange", "LandSet[42].MapRange", "LandSet[43].MapRange", "LandSet[44].MapRange", "LandSet[45].MapRange", "LandSet[46].MapRange", "LandSet[47].MapRange", "LandSet[48].MapRange", "LandSet[49].MapRange", "LandSet[50].MapRange", "LandSet[51].MapRange", "LandSet[52].MapRange", "LandSet[53].MapRange", "LandSet[54].MapRange", "LandSet[55].MapRange", "LandSet[56].MapRange", "LandSet[57].MapRange", "LandSet[58].MapRange", "LandSet[59].MapRange", "LandSet[0].PlacardId", "LandSet[1].PlacardId", "LandSet[2].PlacardId", "LandSet[3].PlacardId", "LandSet[4].PlacardId", "LandSet[5].PlacardId", "LandSet[6].PlacardId", "LandSet[7].PlacardId", "LandSet[8].PlacardId", "LandSet[9].PlacardId", "LandSet[10].PlacardId", "LandSet[11].PlacardId", "LandSet[12].PlacardId", "LandSet[13].PlacardId", "LandSet[14].PlacardId", "LandSet[15].PlacardId", "LandSet[16].PlacardId", "LandSet[17].PlacardId", "LandSet[18].PlacardId", "LandSet[19].PlacardId", "LandSet[20].PlacardId", "LandSet[21].PlacardId", "LandSet[22].PlacardId", "LandSet[23].PlacardId", "LandSet[24].PlacardId", "LandSet[25].PlacardId", "LandSet[26].PlacardId", "LandSet[27].PlacardId", "LandSet[28].PlacardId", "LandSet[29].PlacardId", "LandSet[30].PlacardId", "LandSet[31].PlacardId", "LandSet[32].PlacardId", "LandSet[33].PlacardId", "LandSet[34].PlacardId", "LandSet[35].PlacardId", "LandSet[36].PlacardId", "LandSet[37].PlacardId", "LandSet[38].PlacardId", "LandSet[39].PlacardId", "LandSet[40].PlacardId", "LandSet[41].PlacardId", "LandSet[42].PlacardId", "LandSet[43].PlacardId", "LandSet[44].PlacardId", "LandSet[45].PlacardId", "LandSet[46].PlacardId", "LandSet[47].PlacardId", "LandSet[48].PlacardId", "LandSet[49].PlacardId", "LandSet[50].PlacardId", "LandSet[51].PlacardId", "LandSet[52].PlacardId", "LandSet[53].PlacardId", "LandSet[54].PlacardId", "LandSet[55].PlacardId", "LandSet[56].PlacardId", "LandSet[57].PlacardId", "LandSet[58].PlacardId", "LandSet[59].PlacardId", "LandSet[0].RoomExit", "LandSet[1].RoomExit", "LandSet[2].RoomExit", "LandSet[3].RoomExit", "LandSet[4].RoomExit", "LandSet[5].RoomExit", "LandSet[6].RoomExit", "LandSet[7].RoomExit", "LandSet[8].RoomExit", "LandSet[9].RoomExit", "LandSet[10].RoomExit", "LandSet[11].RoomExit", "LandSet[12].RoomExit", "LandSet[13].RoomExit", "LandSet[14].RoomExit", "LandSet[15].RoomExit", "LandSet[16].RoomExit", "LandSet[17].RoomExit", "LandSet[18].RoomExit", "LandSet[19].RoomExit", "LandSet[20].RoomExit", "LandSet[21].RoomExit", "LandSet[22].RoomExit", "LandSet[23].RoomExit", "LandSet[24].RoomExit", "LandSet[25].RoomExit", "LandSet[26].RoomExit", "LandSet[27].RoomExit", "LandSet[28].RoomExit", "LandSet[29].RoomExit", "LandSet[30].RoomExit", "LandSet[31].RoomExit", "LandSet[32].RoomExit", "LandSet[33].RoomExit", "LandSet[34].RoomExit", "LandSet[35].RoomExit", "LandSet[36].RoomExit", "LandSet[37].RoomExit", "LandSet[38].RoomExit", "LandSet[39].RoomExit", "LandSet[40].RoomExit", "LandSet[41].RoomExit", "LandSet[42].RoomExit", "LandSet[43].RoomExit", "LandSet[44].RoomExit", "LandSet[45].RoomExit", "LandSet[46].RoomExit", "LandSet[47].RoomExit", "LandSet[48].RoomExit", "LandSet[49].RoomExit", "LandSet[50].RoomExit", "LandSet[51].RoomExit", "LandSet[52].RoomExit", "LandSet[53].RoomExit", "LandSet[54].RoomExit", "LandSet[55].RoomExit", "LandSet[56].RoomExit", "LandSet[57].RoomExit", "LandSet[58].RoomExit", "LandSet[59].RoomExit", "LandSet[0].InitialPrice", "LandSet[1].InitialPrice", "LandSet[2].InitialPrice", "LandSet[3].InitialPrice", "LandSet[4].InitialPrice", "LandSet[5].InitialPrice", "LandSet[6].InitialPrice", "LandSet[7].InitialPrice", "LandSet[8].InitialPrice", "LandSet[9].InitialPrice", "LandSet[10].InitialPrice", "LandSet[11].InitialPrice", "LandSet[12].InitialPrice", "LandSet[13].InitialPrice", "LandSet[14].InitialPrice", "LandSet[15].InitialPrice", "LandSet[16].InitialPrice", "LandSet[17].InitialPrice", "LandSet[18].InitialPrice", "LandSet[19].InitialPrice", "LandSet[20].InitialPrice", "LandSet[21].InitialPrice", "LandSet[22].InitialPrice", "LandSet[23].InitialPrice", "LandSet[24].InitialPrice", "LandSet[25].InitialPrice", "LandSet[26].InitialPrice", "LandSet[27].InitialPrice", "LandSet[28].InitialPrice", "LandSet[29].InitialPrice", "LandSet[30].InitialPrice", "LandSet[31].InitialPrice", "LandSet[32].InitialPrice", "LandSet[33].InitialPrice", "LandSet[34].InitialPrice", "LandSet[35].InitialPrice", "LandSet[36].InitialPrice", "LandSet[37].InitialPrice", "LandSet[38].InitialPrice", "LandSet[39].InitialPrice", "LandSet[40].InitialPrice", "LandSet[41].InitialPrice", "LandSet[42].InitialPrice", "LandSet[43].InitialPrice", "LandSet[44].InitialPrice", "LandSet[45].InitialPrice", "LandSet[46].InitialPrice", "LandSet[47].InitialPrice", "LandSet[48].InitialPrice", "LandSet[49].InitialPrice", "LandSet[50].InitialPrice", "LandSet[51].InitialPrice", "LandSet[52].InitialPrice", "LandSet[53].InitialPrice", "LandSet[54].InitialPrice", "LandSet[55].InitialPrice", "LandSet[56].InitialPrice", "LandSet[57].InitialPrice", "LandSet[58].InitialPrice", "LandSet[59].InitialPrice", "MainApartment", "SubdivisionApartment" };

pub const land_set_len = 60;
pub fn landSet(self: @This(), n0: usize) LandSetEntry {
    std.debug.assert(n0 < 60);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const LandSetEntry = struct {
    row: excel.Row,
    at: [1]u16,

    pub fn mapRange(self: @This()) u32 {
        return self.row.at(u32, offsets_1[self.at[0]]);
    }

    pub fn placardId(self: @This()) u32 {
        return self.row.at(u32, offsets_2[self.at[0]]);
    }

    pub fn roomExit(self: @This()) u32 {
        return self.row.at(u32, offsets_3[self.at[0]]);
    }

    pub fn initialPrice(self: @This()) u32 {
        return self.row.at(u32, offsets_4[self.at[0]]);
    }

    pub fn plotSize(self: @This()) u8 {
        return self.row.at(u8, offsets_5[self.at[0]]);
    }
};

pub fn mainApartment(self: @This()) u32 {
    return self.row.at(u32, 1200);
}

pub fn subdivisionApartment(self: @This()) u32 {
    return self.row.at(u32, 1204);
}

const offsets_1 = [60]u16{ 0, 20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, 240, 260, 280, 300, 320, 340, 360, 380, 400, 420, 440, 460, 480, 500, 520, 540, 560, 580, 600, 620, 640, 660, 680, 700, 720, 740, 760, 780, 800, 820, 840, 860, 880, 900, 920, 940, 960, 980, 1000, 1020, 1040, 1060, 1080, 1100, 1120, 1140, 1160, 1180 };
const offsets_2 = [60]u16{ 4, 24, 44, 64, 84, 104, 124, 144, 164, 184, 204, 224, 244, 264, 284, 304, 324, 344, 364, 384, 404, 424, 444, 464, 484, 504, 524, 544, 564, 584, 604, 624, 644, 664, 684, 704, 724, 744, 764, 784, 804, 824, 844, 864, 884, 904, 924, 944, 964, 984, 1004, 1024, 1044, 1064, 1084, 1104, 1124, 1144, 1164, 1184 };
const offsets_3 = [60]u16{ 8, 28, 48, 68, 88, 108, 128, 148, 168, 188, 208, 228, 248, 268, 288, 308, 328, 348, 368, 388, 408, 428, 448, 468, 488, 508, 528, 548, 568, 588, 608, 628, 648, 668, 688, 708, 728, 748, 768, 788, 808, 828, 848, 868, 888, 908, 928, 948, 968, 988, 1008, 1028, 1048, 1068, 1088, 1108, 1128, 1148, 1168, 1188 };
const offsets_4 = [60]u16{ 12, 32, 52, 72, 92, 112, 132, 152, 172, 192, 212, 232, 252, 272, 292, 312, 332, 352, 372, 392, 412, 432, 452, 472, 492, 512, 532, 552, 572, 592, 612, 632, 652, 672, 692, 712, 732, 752, 772, 792, 812, 832, 852, 872, 892, 912, 932, 952, 972, 992, 1012, 1032, 1052, 1072, 1092, 1112, 1132, 1152, 1172, 1192 };
const offsets_5 = [60]u16{ 16, 36, 56, 76, 96, 116, 136, 156, 176, 196, 216, 236, 256, 276, 296, 316, 336, 356, 376, 396, 416, 436, 456, 476, 496, 516, 536, 556, 576, 596, 616, 636, 656, 676, 696, 716, 736, 756, 776, 796, 816, 836, 856, 876, 896, 916, 936, 956, 976, 996, 1016, 1036, 1056, 1076, 1096, 1116, 1136, 1156, 1176, 1196 };
