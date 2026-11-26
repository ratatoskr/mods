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
