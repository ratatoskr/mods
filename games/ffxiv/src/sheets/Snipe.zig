//! `Snipe`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Snipe = @This();

pub const sheet_name = "Snipe";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x88d50061;
pub const Sheet = excel.Typed(Snipe);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "LGBTargetMarker", "Unknown21", "Unknown31", "Unknown24", "Unknown25", "Unknown26", "Unknown27", "Unknown28", "Unknown22", "Unknown29", "Unknown30", "VFXFire", "VFXHit", "VFXMiss", "VFXAdditional", "Unknown23", "Unknown32", "SnipeData[0].DataEventNPC", "SnipeData[1].DataEventNPC", "SnipeData[2].DataEventNPC", "SnipeData[3].DataEventNPC", "SnipeData[4].DataEventNPC", "SnipeData[5].DataEventNPC", "SnipeData[6].DataEventNPC", "SnipeData[7].DataEventNPC", "SnipeData[0].Unknown0", "SnipeData[1].Unknown0", "SnipeData[2].Unknown0", "SnipeData[3].Unknown0", "SnipeData[4].Unknown0", "SnipeData[5].Unknown0", "SnipeData[6].Unknown0", "SnipeData[7].Unknown0", "SnipeData[0].Unknown1", "SnipeData[1].Unknown1", "SnipeData[2].Unknown1", "SnipeData[3].Unknown1", "SnipeData[4].Unknown1", "SnipeData[5].Unknown1", "SnipeData[6].Unknown1", "SnipeData[7].Unknown1", "SnipeData[0].Unknown4", "SnipeData[1].Unknown4", "SnipeData[2].Unknown4", "SnipeData[3].Unknown4", "SnipeData[4].Unknown4", "SnipeData[5].Unknown4", "SnipeData[6].Unknown4", "SnipeData[7].Unknown4", "SnipeData[0].Unknown2", "SnipeData[1].Unknown2", "SnipeData[2].Unknown2", "SnipeData[3].Unknown2", "SnipeData[4].Unknown2", "SnipeData[5].Unknown2", "SnipeData[6].Unknown2", "SnipeData[7].Unknown2", "SnipeData[0].Unknown3", "SnipeData[1].Unknown3", "SnipeData[2].Unknown3", "SnipeData[3].Unknown3", "SnipeData[4].Unknown3", "SnipeData[5].Unknown3", "SnipeData[6].Unknown3", "SnipeData[7].Unknown3", "SnipeData[0].Unknown5", "SnipeData[1].Unknown5", "SnipeData[2].Unknown5", "SnipeData[3].Unknown5", "SnipeData[4].Unknown5", "SnipeData[5].Unknown5", "SnipeData[6].Unknown5", "SnipeData[7].Unknown5", "EventNPC[0]", "EventNPC[1]", "EventNPC[2]", "EventNPC[3]", "EventNPC[4]", "EventNPC[5]", "EventNPC[6]", "EventNPC[7]", "Unknown1", "Unknown4", "Unknown7", "Unknown10", "Unknown2", "Unknown5", "Unknown8", "Unknown11", "Unknown0", "Unknown3", "Unknown6", "Unknown9", "Objective0", "Hint0", "Objective1", "Hint1", "Unknown12", "Unknown13", "Unknown14", "Unknown15", "Unknown16", "Unknown17", "Unknown18", "ActionText", "Unknown19", "Unknown20" };

pub const snipe_data_len = 8;
pub fn snipeData(self: @This(), n0: usize) SnipeDataEntry {
    std.debug.assert(n0 < 8);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const SnipeDataEntry = struct {
    row: excel.Row,
    at: [1]u16,

    pub fn dataEventNPC(self: @This()) u32 {
        return self.row.at(u32, offsets_1[self.at[0]]);
    }

    pub fn unknown0(self: @This()) u16 {
        return self.row.at(u16, offsets_2[self.at[0]]);
    }

    pub fn unknown1(self: @This()) u16 {
        return self.row.at(u16, offsets_3[self.at[0]]);
    }

    pub fn unknown2(self: @This()) u16 {
        return self.row.at(u16, offsets_4[self.at[0]]);
    }

    pub fn unknown3(self: @This()) u16 {
        return self.row.at(u16, offsets_5[self.at[0]]);
    }

    pub fn unknown4(self: @This()) u8 {
        return self.row.at(u8, offsets_6[self.at[0]]);
    }

    pub fn unknown5(self: @This()) u8 {
        return self.row.at(u8, offsets_7[self.at[0]]);
    }
};

pub const event_npc_len = 8;
pub fn eventNPC(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_8[n0]);
}

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 160);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 164);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 166);
}

pub fn unknown3(self: @This()) u32 {
    return self.row.at(u32, 168);
}

pub fn unknown4(self: @This()) u16 {
    return self.row.at(u16, 172);
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 174);
}

pub fn unknown6(self: @This()) u32 {
    return self.row.at(u32, 176);
}

pub fn unknown7(self: @This()) u16 {
    return self.row.at(u16, 180);
}

pub fn unknown8(self: @This()) u8 {
    return self.row.at(u8, 182);
}

pub fn unknown9(self: @This()) u32 {
    return self.row.at(u32, 184);
}

pub fn unknown10(self: @This()) u16 {
    return self.row.at(u16, 188);
}

pub fn unknown11(self: @This()) u8 {
    return self.row.at(u8, 190);
}

pub fn objective0(self: @This()) []const u8 {
    return self.row.stringAt(192);
}

pub fn hint0(self: @This()) []const u8 {
    return self.row.stringAt(196);
}

pub fn objective1(self: @This()) []const u8 {
    return self.row.stringAt(200);
}

pub fn hint1(self: @This()) []const u8 {
    return self.row.stringAt(204);
}

pub fn unknown12(self: @This()) []const u8 {
    return self.row.stringAt(208);
}

pub fn unknown13(self: @This()) []const u8 {
    return self.row.stringAt(212);
}

pub fn unknown14(self: @This()) []const u8 {
    return self.row.stringAt(216);
}

pub fn unknown15(self: @This()) []const u8 {
    return self.row.stringAt(220);
}

pub fn unknown16(self: @This()) []const u8 {
    return self.row.stringAt(224);
}

pub fn unknown17(self: @This()) []const u8 {
    return self.row.stringAt(228);
}

pub fn unknown18(self: @This()) []const u8 {
    return self.row.stringAt(232);
}

pub fn actionText(self: @This()) []const u8 {
    return self.row.stringAt(236);
}

pub fn unknown19(self: @This()) u8 {
    return self.row.at(u8, 240);
}

pub fn unknown20(self: @This()) u8 {
    return self.row.at(u8, 241);
}

pub fn vfxFire(self: @This()) []const u8 {
    return self.row.stringAt(244);
}

pub fn vfxHit(self: @This()) []const u8 {
    return self.row.stringAt(248);
}

pub fn vfxMiss(self: @This()) []const u8 {
    return self.row.stringAt(252);
}

pub fn vfxAdditional(self: @This()) []const u8 {
    return self.row.stringAt(256);
}

pub fn lgbTargetMarker(self: @This()) u32 {
    return self.row.at(u32, 260);
}

pub fn unknown21(self: @This()) u16 {
    return self.row.at(u16, 264);
}

pub fn unknown22(self: @This()) u16 {
    return self.row.at(u16, 266);
}

pub fn unknown23(self: @This()) u16 {
    return self.row.at(u16, 268);
}

pub fn unknown24(self: @This()) u8 {
    return self.row.at(u8, 270);
}

pub fn unknown25(self: @This()) u8 {
    return self.row.at(u8, 271);
}

pub fn unknown26(self: @This()) u8 {
    return self.row.at(u8, 272);
}

pub fn unknown27(self: @This()) u8 {
    return self.row.at(u8, 273);
}

pub fn unknown28(self: @This()) u8 {
    return self.row.at(u8, 274);
}

pub fn unknown29(self: @This()) u8 {
    return self.row.at(u8, 275);
}

pub fn unknown30(self: @This()) u8 {
    return self.row.at(u8, 276);
}

pub fn unknown31(self: @This()) bool {
    return self.row.bitAt(277, 0);
}

pub fn unknown32(self: @This()) bool {
    return self.row.bitAt(277, 1);
}

const offsets_1 = [8]u16{ 0, 16, 32, 48, 64, 80, 96, 112 };
const offsets_2 = [8]u16{ 4, 20, 36, 52, 68, 84, 100, 116 };
const offsets_3 = [8]u16{ 6, 22, 38, 54, 70, 86, 102, 118 };
const offsets_4 = [8]u16{ 8, 24, 40, 56, 72, 88, 104, 120 };
const offsets_5 = [8]u16{ 10, 26, 42, 58, 74, 90, 106, 122 };
const offsets_6 = [8]u16{ 12, 28, 44, 60, 76, 92, 108, 124 };
const offsets_7 = [8]u16{ 13, 29, 45, 61, 77, 93, 109, 125 };
const offsets_8 = [8]u16{ 128, 132, 136, 140, 144, 148, 152, 156 };
