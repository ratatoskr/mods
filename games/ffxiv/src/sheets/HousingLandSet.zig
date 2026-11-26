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
