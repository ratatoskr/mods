//! `CustomTalk`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CustomTalk = @This();

pub const sheet_name = "CustomTalk";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd20fee6c;
pub const Sheet = excel.Typed(CustomTalk);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "IconActor", "IconMap", "Name", "Script[0].ScriptInstruction", "Script[1].ScriptInstruction", "Script[2].ScriptInstruction", "Script[3].ScriptInstruction", "Script[4].ScriptInstruction", "Script[5].ScriptInstruction", "Script[6].ScriptInstruction", "Script[7].ScriptInstruction", "Script[8].ScriptInstruction", "Script[9].ScriptInstruction", "Script[10].ScriptInstruction", "Script[11].ScriptInstruction", "Script[12].ScriptInstruction", "Script[13].ScriptInstruction", "Script[14].ScriptInstruction", "Script[15].ScriptInstruction", "Script[16].ScriptInstruction", "Script[17].ScriptInstruction", "Script[18].ScriptInstruction", "Script[19].ScriptInstruction", "Script[20].ScriptInstruction", "Script[21].ScriptInstruction", "Script[22].ScriptInstruction", "Script[23].ScriptInstruction", "Script[24].ScriptInstruction", "Script[25].ScriptInstruction", "Script[26].ScriptInstruction", "Script[27].ScriptInstruction", "Script[28].ScriptInstruction", "Script[29].ScriptInstruction", "Script[0].ScriptArg", "Script[1].ScriptArg", "Script[2].ScriptArg", "Script[3].ScriptArg", "Script[4].ScriptArg", "Script[5].ScriptArg", "Script[6].ScriptArg", "Script[7].ScriptArg", "Script[8].ScriptArg", "Script[9].ScriptArg", "Script[10].ScriptArg", "Script[11].ScriptArg", "Script[12].ScriptArg", "Script[13].ScriptArg", "Script[14].ScriptArg", "Script[15].ScriptArg", "Script[16].ScriptArg", "Script[17].ScriptArg", "Script[18].ScriptArg", "Script[19].ScriptArg", "Script[20].ScriptArg", "Script[21].ScriptArg", "Script[22].ScriptArg", "Script[23].ScriptArg", "Script[24].ScriptArg", "Script[25].ScriptArg", "Script[26].ScriptArg", "Script[27].ScriptArg", "Script[28].ScriptArg", "Script[29].ScriptArg", "Unknown2", "MainOption", "SubOption", "Unknown3", "Unknown4", "Unknown5", "Unknown6", "Unknown7", "Unknown8", "Unknown9", "Unknown10", "Unknown11", "SpecialLinks", "Unknown0", "Unknown1", "Unknown12" };

pub const script_len = 30;
pub fn script(self: @This(), n0: usize) ScriptEntry {
    std.debug.assert(n0 < 30);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const ScriptEntry = struct {
    row: excel.Row,
    at: [1]u16,

    pub fn scriptInstruction(self: @This()) []const u8 {
        return self.row.stringAt(offsets_1[self.at[0]]);
    }

    pub fn scriptArg(self: @This()) u32 {
        return self.row.at(u32, offsets_2[self.at[0]]);
    }
};

pub fn mainOption(self: @This()) []const u8 {
    return self.row.stringAt(240);
}

pub fn subOption(self: @This()) []const u8 {
    return self.row.stringAt(244);
}

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(248);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn iconActor(self: @This()) u32 {
    return self.row.at(u32, 252);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn iconMap(self: @This()) u32 {
    return self.row.at(u32, 256);
}

/// Links to `CollectablesShop`, `ContentEntry`, `SpecialShop` or `CustomTalkNestHandlers`, whichever has the row.
pub fn specialLinks(self: @This()) u32 {
    return self.row.at(u32, 260);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 264);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 265);
}

pub fn unknown2(self: @This()) bool {
    return self.row.bitAt(266, 0);
}

pub fn unknown3(self: @This()) bool {
    return self.row.bitAt(266, 1);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(266, 2);
}

pub fn unknown5(self: @This()) bool {
    return self.row.bitAt(266, 3);
}

pub fn unknown6(self: @This()) bool {
    return self.row.bitAt(266, 4);
}

pub fn unknown7(self: @This()) bool {
    return self.row.bitAt(266, 5);
}

pub fn unknown8(self: @This()) bool {
    return self.row.bitAt(266, 6);
}

pub fn unknown9(self: @This()) bool {
    return self.row.bitAt(266, 7);
}

pub fn unknown10(self: @This()) bool {
    return self.row.bitAt(267, 0);
}

pub fn unknown11(self: @This()) bool {
    return self.row.bitAt(267, 1);
}

pub fn unknown12(self: @This()) bool {
    return self.row.bitAt(267, 2);
}

const offsets_1 = [30]u16{ 0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120, 128, 136, 144, 152, 160, 168, 176, 184, 192, 200, 208, 216, 224, 232 };
const offsets_2 = [30]u16{ 4, 12, 20, 28, 36, 44, 52, 60, 68, 76, 84, 92, 100, 108, 116, 124, 132, 140, 148, 156, 164, 172, 180, 188, 196, 204, 212, 220, 228, 236 };
