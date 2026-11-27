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

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "ClassJob", "ClassBook", "MemberParams[0].EquipPreset", "MemberParams[1].EquipPreset", "MemberParams[2].EquipPreset", "MemberParams[3].EquipPreset", "MemberParams[4].EquipPreset", "MemberParams[5].EquipPreset", "MemberParams[6].EquipPreset", "MemberParams[7].EquipPreset", "MemberParams[8].EquipPreset", "MemberParams[9].EquipPreset", "MemberParams[10].EquipPreset", "MemberParams[11].EquipPreset", "MemberParams[12].EquipPreset", "MemberParams[13].EquipPreset", "MemberParams[14].EquipPreset", "MemberParams[15].EquipPreset", "MemberParams[16].EquipPreset", "MemberParams[17].EquipPreset", "MemberParams[18].EquipPreset", "MemberParams[19].EquipPreset", "MemberParams[20].EquipPreset", "MemberParams[21].EquipPreset", "MemberParams[22].EquipPreset", "MemberParams[23].EquipPreset", "MemberParams[24].EquipPreset", "MemberParams[25].EquipPreset", "MemberParams[26].EquipPreset", "MemberParams[27].EquipPreset", "MemberParams[28].EquipPreset", "MemberParams[29].EquipPreset", "MemberParams[30].EquipPreset", "MemberParams[31].EquipPreset", "MemberParams[32].EquipPreset", "MemberParams[33].EquipPreset", "MemberParams[34].EquipPreset", "MemberParams[35].EquipPreset", "MemberParams[36].EquipPreset", "MemberParams[37].EquipPreset", "MemberParams[38].EquipPreset", "MemberParams[39].EquipPreset", "MemberParams[40].EquipPreset", "MemberParams[41].EquipPreset", "MemberParams[42].EquipPreset", "MemberParams[43].EquipPreset", "MemberParams[44].EquipPreset", "MemberParams[45].EquipPreset", "MemberParams[46].EquipPreset", "MemberParams[47].EquipPreset", "MemberParams[48].EquipPreset", "MemberParams[49].EquipPreset", "MemberParams[50].EquipPreset", "MemberParams[51].EquipPreset", "MemberParams[52].EquipPreset", "MemberParams[53].EquipPreset", "MemberParams[54].EquipPreset", "MemberParams[55].EquipPreset", "MemberParams[56].EquipPreset", "MemberParams[57].EquipPreset", "MemberParams[58].EquipPreset", "MemberParams[59].EquipPreset", "Unknown0", "MemberParams[0].Physical", "MemberParams[1].Physical", "MemberParams[2].Physical", "MemberParams[3].Physical", "MemberParams[4].Physical", "MemberParams[5].Physical", "MemberParams[6].Physical", "MemberParams[7].Physical", "MemberParams[8].Physical", "MemberParams[9].Physical", "MemberParams[10].Physical", "MemberParams[11].Physical", "MemberParams[12].Physical", "MemberParams[13].Physical", "MemberParams[14].Physical", "MemberParams[15].Physical", "MemberParams[16].Physical", "MemberParams[17].Physical", "MemberParams[18].Physical", "MemberParams[19].Physical", "MemberParams[20].Physical", "MemberParams[21].Physical", "MemberParams[22].Physical", "MemberParams[23].Physical", "MemberParams[24].Physical", "MemberParams[25].Physical", "MemberParams[26].Physical", "MemberParams[27].Physical", "MemberParams[28].Physical", "MemberParams[29].Physical", "MemberParams[30].Physical", "MemberParams[31].Physical", "MemberParams[32].Physical", "MemberParams[33].Physical", "MemberParams[34].Physical", "MemberParams[35].Physical", "MemberParams[36].Physical", "MemberParams[37].Physical", "MemberParams[38].Physical", "MemberParams[39].Physical", "MemberParams[40].Physical", "MemberParams[41].Physical", "MemberParams[42].Physical", "MemberParams[43].Physical", "MemberParams[44].Physical", "MemberParams[45].Physical", "MemberParams[46].Physical", "MemberParams[47].Physical", "MemberParams[48].Physical", "MemberParams[49].Physical", "MemberParams[50].Physical", "MemberParams[51].Physical", "MemberParams[52].Physical", "MemberParams[53].Physical", "MemberParams[54].Physical", "MemberParams[55].Physical", "MemberParams[56].Physical", "MemberParams[57].Physical", "MemberParams[58].Physical", "MemberParams[59].Physical", "Unknown1", "MemberParams[0].Mental", "MemberParams[1].Mental", "MemberParams[2].Mental", "MemberParams[3].Mental", "MemberParams[4].Mental", "MemberParams[5].Mental", "MemberParams[6].Mental", "MemberParams[7].Mental", "MemberParams[8].Mental", "MemberParams[9].Mental", "MemberParams[10].Mental", "MemberParams[11].Mental", "MemberParams[12].Mental", "MemberParams[13].Mental", "MemberParams[14].Mental", "MemberParams[15].Mental", "MemberParams[16].Mental", "MemberParams[17].Mental", "MemberParams[18].Mental", "MemberParams[19].Mental", "MemberParams[20].Mental", "MemberParams[21].Mental", "MemberParams[22].Mental", "MemberParams[23].Mental", "MemberParams[24].Mental", "MemberParams[25].Mental", "MemberParams[26].Mental", "MemberParams[27].Mental", "MemberParams[28].Mental", "MemberParams[29].Mental", "MemberParams[30].Mental", "MemberParams[31].Mental", "MemberParams[32].Mental", "MemberParams[33].Mental", "MemberParams[34].Mental", "MemberParams[35].Mental", "MemberParams[36].Mental", "MemberParams[37].Mental", "MemberParams[38].Mental", "MemberParams[39].Mental", "MemberParams[40].Mental", "MemberParams[41].Mental", "MemberParams[42].Mental", "MemberParams[43].Mental", "MemberParams[44].Mental", "MemberParams[45].Mental", "MemberParams[46].Mental", "MemberParams[47].Mental", "MemberParams[48].Mental", "MemberParams[49].Mental", "MemberParams[50].Mental", "MemberParams[51].Mental", "MemberParams[52].Mental", "MemberParams[53].Mental", "MemberParams[54].Mental", "MemberParams[55].Mental", "MemberParams[56].Mental", "MemberParams[57].Mental", "MemberParams[58].Mental", "MemberParams[59].Mental", "Unknown2", "MemberParams[0].Tactical", "MemberParams[1].Tactical", "MemberParams[2].Tactical", "MemberParams[3].Tactical", "MemberParams[4].Tactical", "MemberParams[5].Tactical", "MemberParams[6].Tactical", "MemberParams[7].Tactical", "MemberParams[8].Tactical", "MemberParams[9].Tactical", "MemberParams[10].Tactical", "MemberParams[11].Tactical", "MemberParams[12].Tactical", "MemberParams[13].Tactical", "MemberParams[14].Tactical", "MemberParams[15].Tactical", "MemberParams[16].Tactical", "MemberParams[17].Tactical", "MemberParams[18].Tactical", "MemberParams[19].Tactical", "MemberParams[20].Tactical", "MemberParams[21].Tactical", "MemberParams[22].Tactical", "MemberParams[23].Tactical", "MemberParams[24].Tactical", "MemberParams[25].Tactical", "MemberParams[26].Tactical", "MemberParams[27].Tactical", "MemberParams[28].Tactical", "MemberParams[29].Tactical", "MemberParams[30].Tactical", "MemberParams[31].Tactical", "MemberParams[32].Tactical", "MemberParams[33].Tactical", "MemberParams[34].Tactical", "MemberParams[35].Tactical", "MemberParams[36].Tactical", "MemberParams[37].Tactical", "MemberParams[38].Tactical", "MemberParams[39].Tactical", "MemberParams[40].Tactical", "MemberParams[41].Tactical", "MemberParams[42].Tactical", "MemberParams[43].Tactical", "MemberParams[44].Tactical", "MemberParams[45].Tactical", "MemberParams[46].Tactical", "MemberParams[47].Tactical", "MemberParams[48].Tactical", "MemberParams[49].Tactical", "MemberParams[50].Tactical", "MemberParams[51].Tactical", "MemberParams[52].Tactical", "MemberParams[53].Tactical", "MemberParams[54].Tactical", "MemberParams[55].Tactical", "MemberParams[56].Tactical", "MemberParams[57].Tactical", "MemberParams[58].Tactical", "MemberParams[59].Tactical", "Unknown3" };

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
