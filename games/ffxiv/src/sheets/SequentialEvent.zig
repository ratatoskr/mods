//! `SequentialEvent`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SequentialEvent = @This();

pub const sheet_name = "SequentialEvent";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xb14c0c35;
pub const Sheet = excel.Typed(SequentialEvent);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown321", "Unknown320", "Unknown_70", "UnknownStruct[0].Unknown3", "UnknownStruct[1].Unknown3", "UnknownStruct[2].Unknown3", "UnknownStruct[3].Unknown3", "UnknownStruct[4].Unknown3", "UnknownStruct[5].Unknown3", "UnknownStruct[6].Unknown3", "UnknownStruct[7].Unknown3", "UnknownStruct[8].Unknown3", "UnknownStruct[9].Unknown3", "UnknownStruct[10].Unknown3", "UnknownStruct[11].Unknown3", "UnknownStruct[12].Unknown3", "UnknownStruct[13].Unknown3", "UnknownStruct[14].Unknown3", "UnknownStruct[15].Unknown3", "UnknownStruct[16].Unknown3", "UnknownStruct[17].Unknown3", "UnknownStruct[18].Unknown3", "UnknownStruct[19].Unknown3", "UnknownStruct[20].Unknown3", "UnknownStruct[21].Unknown3", "UnknownStruct[22].Unknown3", "UnknownStruct[23].Unknown3", "UnknownStruct[24].Unknown3", "UnknownStruct[25].Unknown3", "UnknownStruct[26].Unknown3", "UnknownStruct[27].Unknown3", "UnknownStruct[28].Unknown3", "UnknownStruct[29].Unknown3", "UnknownStruct[30].Unknown3", "UnknownStruct[31].Unknown3", "UnknownStruct[32].Unknown3", "UnknownStruct[33].Unknown3", "UnknownStruct[34].Unknown3", "UnknownStruct[35].Unknown3", "UnknownStruct[36].Unknown3", "UnknownStruct[37].Unknown3", "UnknownStruct[38].Unknown3", "UnknownStruct[39].Unknown3", "UnknownStruct[40].Unknown3", "UnknownStruct[41].Unknown3", "UnknownStruct[42].Unknown3", "UnknownStruct[43].Unknown3", "UnknownStruct[44].Unknown3", "UnknownStruct[45].Unknown3", "UnknownStruct[46].Unknown3", "UnknownStruct[47].Unknown3", "UnknownStruct[48].Unknown3", "UnknownStruct[49].Unknown3", "UnknownStruct[50].Unknown3", "UnknownStruct[51].Unknown3", "UnknownStruct[52].Unknown3", "UnknownStruct[53].Unknown3", "UnknownStruct[54].Unknown3", "UnknownStruct[55].Unknown3", "UnknownStruct[56].Unknown3", "UnknownStruct[57].Unknown3", "UnknownStruct[58].Unknown3", "UnknownStruct[59].Unknown3", "UnknownStruct[60].Unknown3", "UnknownStruct[61].Unknown3", "UnknownStruct[62].Unknown3", "UnknownStruct[63].Unknown3", "UnknownStruct[0].Unknown1", "UnknownStruct[1].Unknown1", "UnknownStruct[2].Unknown1", "UnknownStruct[3].Unknown1", "UnknownStruct[4].Unknown1", "UnknownStruct[5].Unknown1", "UnknownStruct[6].Unknown1", "UnknownStruct[7].Unknown1", "UnknownStruct[8].Unknown1", "UnknownStruct[9].Unknown1", "UnknownStruct[10].Unknown1", "UnknownStruct[11].Unknown1", "UnknownStruct[12].Unknown1", "UnknownStruct[13].Unknown1", "UnknownStruct[14].Unknown1", "UnknownStruct[15].Unknown1", "UnknownStruct[16].Unknown1", "UnknownStruct[17].Unknown1", "UnknownStruct[18].Unknown1", "UnknownStruct[19].Unknown1", "UnknownStruct[20].Unknown1", "UnknownStruct[21].Unknown1", "UnknownStruct[22].Unknown1", "UnknownStruct[23].Unknown1", "UnknownStruct[24].Unknown1", "UnknownStruct[25].Unknown1", "UnknownStruct[26].Unknown1", "UnknownStruct[27].Unknown1", "UnknownStruct[28].Unknown1", "UnknownStruct[29].Unknown1", "UnknownStruct[30].Unknown1", "UnknownStruct[31].Unknown1", "UnknownStruct[32].Unknown1", "UnknownStruct[33].Unknown1", "UnknownStruct[34].Unknown1", "UnknownStruct[35].Unknown1", "UnknownStruct[36].Unknown1", "UnknownStruct[37].Unknown1", "UnknownStruct[38].Unknown1", "UnknownStruct[39].Unknown1", "UnknownStruct[40].Unknown1", "UnknownStruct[41].Unknown1", "UnknownStruct[42].Unknown1", "UnknownStruct[43].Unknown1", "UnknownStruct[44].Unknown1", "UnknownStruct[45].Unknown1", "UnknownStruct[46].Unknown1", "UnknownStruct[47].Unknown1", "UnknownStruct[48].Unknown1", "UnknownStruct[49].Unknown1", "UnknownStruct[50].Unknown1", "UnknownStruct[51].Unknown1", "UnknownStruct[52].Unknown1", "UnknownStruct[53].Unknown1", "UnknownStruct[54].Unknown1", "UnknownStruct[55].Unknown1", "UnknownStruct[56].Unknown1", "UnknownStruct[57].Unknown1", "UnknownStruct[58].Unknown1", "UnknownStruct[59].Unknown1", "UnknownStruct[60].Unknown1", "UnknownStruct[61].Unknown1", "UnknownStruct[62].Unknown1", "UnknownStruct[63].Unknown1", "UnknownStruct[0].Unknown2", "UnknownStruct[1].Unknown2", "UnknownStruct[2].Unknown2", "UnknownStruct[3].Unknown2", "UnknownStruct[4].Unknown2", "UnknownStruct[5].Unknown2", "UnknownStruct[6].Unknown2", "UnknownStruct[7].Unknown2", "UnknownStruct[8].Unknown2", "UnknownStruct[9].Unknown2", "UnknownStruct[10].Unknown2", "UnknownStruct[11].Unknown2", "UnknownStruct[12].Unknown2", "UnknownStruct[13].Unknown2", "UnknownStruct[14].Unknown2", "UnknownStruct[15].Unknown2", "UnknownStruct[16].Unknown2", "UnknownStruct[17].Unknown2", "UnknownStruct[18].Unknown2", "UnknownStruct[19].Unknown2", "UnknownStruct[20].Unknown2", "UnknownStruct[21].Unknown2", "UnknownStruct[22].Unknown2", "UnknownStruct[23].Unknown2", "UnknownStruct[24].Unknown2", "UnknownStruct[25].Unknown2", "UnknownStruct[26].Unknown2", "UnknownStruct[27].Unknown2", "UnknownStruct[28].Unknown2", "UnknownStruct[29].Unknown2", "UnknownStruct[30].Unknown2", "UnknownStruct[31].Unknown2", "UnknownStruct[32].Unknown2", "UnknownStruct[33].Unknown2", "UnknownStruct[34].Unknown2", "UnknownStruct[35].Unknown2", "UnknownStruct[36].Unknown2", "UnknownStruct[37].Unknown2", "UnknownStruct[38].Unknown2", "UnknownStruct[39].Unknown2", "UnknownStruct[40].Unknown2", "UnknownStruct[41].Unknown2", "UnknownStruct[42].Unknown2", "UnknownStruct[43].Unknown2", "UnknownStruct[44].Unknown2", "UnknownStruct[45].Unknown2", "UnknownStruct[46].Unknown2", "UnknownStruct[47].Unknown2", "UnknownStruct[48].Unknown2", "UnknownStruct[49].Unknown2", "UnknownStruct[50].Unknown2", "UnknownStruct[51].Unknown2", "UnknownStruct[52].Unknown2", "UnknownStruct[53].Unknown2", "UnknownStruct[54].Unknown2", "UnknownStruct[55].Unknown2", "UnknownStruct[56].Unknown2", "UnknownStruct[57].Unknown2", "UnknownStruct[58].Unknown2", "UnknownStruct[59].Unknown2", "UnknownStruct[60].Unknown2", "UnknownStruct[61].Unknown2", "UnknownStruct[62].Unknown2", "UnknownStruct[63].Unknown2", "UnknownStruct[0].Unknown4", "UnknownStruct[1].Unknown4", "UnknownStruct[2].Unknown4", "UnknownStruct[3].Unknown4", "UnknownStruct[4].Unknown4", "UnknownStruct[5].Unknown4", "UnknownStruct[6].Unknown4", "UnknownStruct[7].Unknown4", "UnknownStruct[8].Unknown4", "UnknownStruct[9].Unknown4", "UnknownStruct[10].Unknown4", "UnknownStruct[11].Unknown4", "UnknownStruct[12].Unknown4", "UnknownStruct[13].Unknown4", "UnknownStruct[14].Unknown4", "UnknownStruct[15].Unknown4", "UnknownStruct[16].Unknown4", "UnknownStruct[17].Unknown4", "UnknownStruct[18].Unknown4", "UnknownStruct[19].Unknown4", "UnknownStruct[20].Unknown4", "UnknownStruct[21].Unknown4", "UnknownStruct[22].Unknown4", "UnknownStruct[23].Unknown4", "UnknownStruct[24].Unknown4", "UnknownStruct[25].Unknown4", "UnknownStruct[26].Unknown4", "UnknownStruct[27].Unknown4", "UnknownStruct[28].Unknown4", "UnknownStruct[29].Unknown4", "UnknownStruct[30].Unknown4", "UnknownStruct[31].Unknown4", "UnknownStruct[32].Unknown4", "UnknownStruct[33].Unknown4", "UnknownStruct[34].Unknown4", "UnknownStruct[35].Unknown4", "UnknownStruct[36].Unknown4", "UnknownStruct[37].Unknown4", "UnknownStruct[38].Unknown4", "UnknownStruct[39].Unknown4", "UnknownStruct[40].Unknown4", "UnknownStruct[41].Unknown4", "UnknownStruct[42].Unknown4", "UnknownStruct[43].Unknown4", "UnknownStruct[44].Unknown4", "UnknownStruct[45].Unknown4", "UnknownStruct[46].Unknown4", "UnknownStruct[47].Unknown4", "UnknownStruct[48].Unknown4", "UnknownStruct[49].Unknown4", "UnknownStruct[50].Unknown4", "UnknownStruct[51].Unknown4", "UnknownStruct[52].Unknown4", "UnknownStruct[53].Unknown4", "UnknownStruct[54].Unknown4", "UnknownStruct[55].Unknown4", "UnknownStruct[56].Unknown4", "UnknownStruct[57].Unknown4", "UnknownStruct[58].Unknown4", "UnknownStruct[59].Unknown4", "UnknownStruct[60].Unknown4", "UnknownStruct[61].Unknown4", "UnknownStruct[62].Unknown4", "UnknownStruct[63].Unknown4", "UnknownStruct[0].Unknown5", "UnknownStruct[1].Unknown5", "UnknownStruct[2].Unknown5", "UnknownStruct[3].Unknown5", "UnknownStruct[4].Unknown5", "UnknownStruct[5].Unknown5", "UnknownStruct[6].Unknown5", "UnknownStruct[7].Unknown5", "UnknownStruct[8].Unknown5", "UnknownStruct[9].Unknown5", "UnknownStruct[10].Unknown5", "UnknownStruct[11].Unknown5", "UnknownStruct[12].Unknown5", "UnknownStruct[13].Unknown5", "UnknownStruct[14].Unknown5", "UnknownStruct[15].Unknown5", "UnknownStruct[16].Unknown5", "UnknownStruct[17].Unknown5", "UnknownStruct[18].Unknown5", "UnknownStruct[19].Unknown5", "UnknownStruct[20].Unknown5", "UnknownStruct[21].Unknown5", "UnknownStruct[22].Unknown5", "UnknownStruct[23].Unknown5", "UnknownStruct[24].Unknown5", "UnknownStruct[25].Unknown5", "UnknownStruct[26].Unknown5", "UnknownStruct[27].Unknown5", "UnknownStruct[28].Unknown5", "UnknownStruct[29].Unknown5", "UnknownStruct[30].Unknown5", "UnknownStruct[31].Unknown5", "UnknownStruct[32].Unknown5", "UnknownStruct[33].Unknown5", "UnknownStruct[34].Unknown5", "UnknownStruct[35].Unknown5", "UnknownStruct[36].Unknown5", "UnknownStruct[37].Unknown5", "UnknownStruct[38].Unknown5", "UnknownStruct[39].Unknown5", "UnknownStruct[40].Unknown5", "UnknownStruct[41].Unknown5", "UnknownStruct[42].Unknown5", "UnknownStruct[43].Unknown5", "UnknownStruct[44].Unknown5", "UnknownStruct[45].Unknown5", "UnknownStruct[46].Unknown5", "UnknownStruct[47].Unknown5", "UnknownStruct[48].Unknown5", "UnknownStruct[49].Unknown5", "UnknownStruct[50].Unknown5", "UnknownStruct[51].Unknown5", "UnknownStruct[52].Unknown5", "UnknownStruct[53].Unknown5", "UnknownStruct[54].Unknown5", "UnknownStruct[55].Unknown5", "UnknownStruct[56].Unknown5", "UnknownStruct[57].Unknown5", "UnknownStruct[58].Unknown5", "UnknownStruct[59].Unknown5", "UnknownStruct[60].Unknown5", "UnknownStruct[61].Unknown5", "UnknownStruct[62].Unknown5", "UnknownStruct[63].Unknown5" };

pub const unknown_struct_len = 64;
pub fn unknownStruct(self: @This(), n0: usize) UnknownStructEntry {
    std.debug.assert(n0 < 64);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const UnknownStructEntry = struct {
    row: excel.Row,
    at: [1]u16,

    pub fn unknown1(self: @This()) u32 {
        return self.row.at(u32, offsets_1[self.at[0]]);
    }

    pub fn unknown2(self: @This()) u32 {
        return self.row.at(u32, offsets_2[self.at[0]]);
    }

    pub fn unknown3(self: @This()) u16 {
        return self.row.at(u16, offsets_3[self.at[0]]);
    }

    pub fn unknown4(self: @This()) u16 {
        return self.row.at(u16, offsets_4[self.at[0]]);
    }

    pub fn unknown5(self: @This()) u16 {
        return self.row.at(u16, offsets_5[self.at[0]]);
    }
};

pub fn unknown320(self: @This()) u32 {
    return self.row.at(u32, 1024);
}

pub fn unknown_70(self: @This()) u32 {
    return self.row.at(u32, 1028);
}

pub fn unknown321(self: @This()) u16 {
    return self.row.at(u16, 1032);
}

const offsets_1 = [64]u16{ 0, 16, 32, 48, 64, 80, 96, 112, 128, 144, 160, 176, 192, 208, 224, 240, 256, 272, 288, 304, 320, 336, 352, 368, 384, 400, 416, 432, 448, 464, 480, 496, 512, 528, 544, 560, 576, 592, 608, 624, 640, 656, 672, 688, 704, 720, 736, 752, 768, 784, 800, 816, 832, 848, 864, 880, 896, 912, 928, 944, 960, 976, 992, 1008 };
const offsets_2 = [64]u16{ 4, 20, 36, 52, 68, 84, 100, 116, 132, 148, 164, 180, 196, 212, 228, 244, 260, 276, 292, 308, 324, 340, 356, 372, 388, 404, 420, 436, 452, 468, 484, 500, 516, 532, 548, 564, 580, 596, 612, 628, 644, 660, 676, 692, 708, 724, 740, 756, 772, 788, 804, 820, 836, 852, 868, 884, 900, 916, 932, 948, 964, 980, 996, 1012 };
const offsets_3 = [64]u16{ 8, 24, 40, 56, 72, 88, 104, 120, 136, 152, 168, 184, 200, 216, 232, 248, 264, 280, 296, 312, 328, 344, 360, 376, 392, 408, 424, 440, 456, 472, 488, 504, 520, 536, 552, 568, 584, 600, 616, 632, 648, 664, 680, 696, 712, 728, 744, 760, 776, 792, 808, 824, 840, 856, 872, 888, 904, 920, 936, 952, 968, 984, 1000, 1016 };
const offsets_4 = [64]u16{ 10, 26, 42, 58, 74, 90, 106, 122, 138, 154, 170, 186, 202, 218, 234, 250, 266, 282, 298, 314, 330, 346, 362, 378, 394, 410, 426, 442, 458, 474, 490, 506, 522, 538, 554, 570, 586, 602, 618, 634, 650, 666, 682, 698, 714, 730, 746, 762, 778, 794, 810, 826, 842, 858, 874, 890, 906, 922, 938, 954, 970, 986, 1002, 1018 };
const offsets_5 = [64]u16{ 12, 28, 44, 60, 76, 92, 108, 124, 140, 156, 172, 188, 204, 220, 236, 252, 268, 284, 300, 316, 332, 348, 364, 380, 396, 412, 428, 444, 460, 476, 492, 508, 524, 540, 556, 572, 588, 604, 620, 636, 652, 668, 684, 700, 716, 732, 748, 764, 780, 796, 812, 828, 844, 860, 876, 892, 908, 924, 940, 956, 972, 988, 1004, 1020 };
