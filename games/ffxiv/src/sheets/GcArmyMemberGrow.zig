//! `GcArmyMemberGrow`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GcArmyMemberGrow = @This();

pub const sheet_name = "GcArmyMemberGrow";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xaf66261c;
pub const Sheet = excel.Typed(GcArmyMemberGrow);

row: excel.Row,

pub const member_params_len = 60;
pub fn memberParams(self: @This(), n0: usize) MemberParamsEntry {
    std.debug.assert(n0 < 60);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const MemberParamsEntry = struct {
    row: excel.Row,
    at: [1]u16,

    /// Links to `GcArmyEquipPreset`.
    pub fn equipPreset(self: @This()) excel.Link(sheets.GcArmyEquipPreset) {
        return .of(self.row.at(u16, offsets_1[self.at[0]]));
    }

    pub fn physical(self: @This()) u8 {
        return self.row.at(u8, offsets_2[self.at[0]]);
    }

    pub fn mental(self: @This()) u8 {
        return self.row.at(u8, offsets_3[self.at[0]]);
    }

    pub fn tactical(self: @This()) u8 {
        return self.row.at(u8, offsets_4[self.at[0]]);
    }
};

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 360);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 362);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 363);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 364);
}

/// Links to `Item`.
pub fn classBook(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 368));
}

/// Links to `ClassJob`.
pub fn classJob(self: @This()) excel.Link(sheets.ClassJob) {
    return .of(self.row.at(u8, 372));
}

const offsets_1 = [60]u16{ 0, 6, 12, 18, 24, 30, 36, 42, 48, 54, 60, 66, 72, 78, 84, 90, 96, 102, 108, 114, 120, 126, 132, 138, 144, 150, 156, 162, 168, 174, 180, 186, 192, 198, 204, 210, 216, 222, 228, 234, 240, 246, 252, 258, 264, 270, 276, 282, 288, 294, 300, 306, 312, 318, 324, 330, 336, 342, 348, 354 };
const offsets_2 = [60]u16{ 2, 8, 14, 20, 26, 32, 38, 44, 50, 56, 62, 68, 74, 80, 86, 92, 98, 104, 110, 116, 122, 128, 134, 140, 146, 152, 158, 164, 170, 176, 182, 188, 194, 200, 206, 212, 218, 224, 230, 236, 242, 248, 254, 260, 266, 272, 278, 284, 290, 296, 302, 308, 314, 320, 326, 332, 338, 344, 350, 356 };
const offsets_3 = [60]u16{ 3, 9, 15, 21, 27, 33, 39, 45, 51, 57, 63, 69, 75, 81, 87, 93, 99, 105, 111, 117, 123, 129, 135, 141, 147, 153, 159, 165, 171, 177, 183, 189, 195, 201, 207, 213, 219, 225, 231, 237, 243, 249, 255, 261, 267, 273, 279, 285, 291, 297, 303, 309, 315, 321, 327, 333, 339, 345, 351, 357 };
const offsets_4 = [60]u16{ 4, 10, 16, 22, 28, 34, 40, 46, 52, 58, 64, 70, 76, 82, 88, 94, 100, 106, 112, 118, 124, 130, 136, 142, 148, 154, 160, 166, 172, 178, 184, 190, 196, 202, 208, 214, 220, 226, 232, 238, 244, 250, 256, 262, 268, 274, 280, 286, 292, 298, 304, 310, 316, 322, 328, 334, 340, 346, 352, 358 };
