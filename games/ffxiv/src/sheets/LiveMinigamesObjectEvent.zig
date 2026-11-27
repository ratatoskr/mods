//! `LiveMinigamesObjectEvent`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const LiveMinigamesObjectEvent = @This();

pub const sheet_name = "LiveMinigamesObjectEvent";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x1844fac3;
pub const Sheet = excel.Typed(LiveMinigamesObjectEvent);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown7", "Unknown39", "Unknown8", "Unknown9", "Unknown40", "Unknown12", "Unknown43", "Unknown15", "Unknown10", "Unknown41", "Unknown13", "Unknown44", "Unknown16", "Unknown11", "Unknown42", "Unknown14", "Unknown45[0]", "Unknown17", "Unknown18[0]", "Unknown0[0]", "Unknown25[0]", "Unknown32[0]", "Unknown45[1]", "Unknown18[1]", "Unknown0[1]", "Unknown25[1]", "Unknown32[1]", "Unknown45[2]", "Unknown18[2]", "Unknown0[2]", "Unknown25[2]", "Unknown32[2]", "Unknown45[3]", "Unknown18[3]", "Unknown0[3]", "Unknown25[3]", "Unknown32[3]", "Unknown45[4]", "Unknown18[4]", "Unknown0[4]", "Unknown25[4]", "Unknown32[4]", "Unknown45[5]", "Unknown18[5]", "Unknown0[5]", "Unknown25[5]", "Unknown32[5]", "Unknown45[6]", "Unknown18[6]", "Unknown0[6]", "Unknown25[6]", "Unknown32[6]", "Unknown52" };

pub const unknown0_len = 7;
pub fn unknown0(self: @This(), n0: usize) f32 {
    return self.row.at(f32, offsets_1[n0]);
}

pub fn unknown7(self: @This()) u32 {
    return self.row.at(u32, 28);
}

pub fn unknown8(self: @This()) u32 {
    return self.row.at(u32, 32);
}

pub fn unknown9(self: @This()) u32 {
    return self.row.at(u32, 36);
}

pub fn unknown10(self: @This()) u32 {
    return self.row.at(u32, 40);
}

pub fn unknown11(self: @This()) u32 {
    return self.row.at(u32, 44);
}

pub fn unknown12(self: @This()) u32 {
    return self.row.at(u32, 48);
}

pub fn unknown13(self: @This()) u32 {
    return self.row.at(u32, 52);
}

pub fn unknown14(self: @This()) u32 {
    return self.row.at(u32, 56);
}

pub fn unknown15(self: @This()) u32 {
    return self.row.at(u32, 60);
}

pub fn unknown16(self: @This()) u32 {
    return self.row.at(u32, 64);
}

pub fn unknown17(self: @This()) u32 {
    return self.row.at(u32, 68);
}

pub const unknown18_len = 7;
pub fn unknown18(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_2[n0]);
}

pub const unknown25_len = 7;
/// Meaning of the value depends on Unknown18
pub fn unknown25(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_3[n0]);
}

pub const unknown32_len = 7;
pub fn unknown32(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_4[n0]);
}

pub fn unknown39(self: @This()) i32 {
    return self.row.at(i32, 156);
}

pub fn unknown40(self: @This()) i32 {
    return self.row.at(i32, 160);
}

pub fn unknown41(self: @This()) i32 {
    return self.row.at(i32, 164);
}

pub fn unknown42(self: @This()) i32 {
    return self.row.at(i32, 168);
}

pub fn unknown43(self: @This()) i32 {
    return self.row.at(i32, 172);
}

pub fn unknown44(self: @This()) i32 {
    return self.row.at(i32, 176);
}

pub const unknown45_len = 7;
pub fn unknown45(self: @This(), n0: usize) i32 {
    return self.row.at(i32, offsets_5[n0]);
}

pub fn unknown52(self: @This()) i32 {
    return self.row.at(i32, 208);
}

const offsets_1 = [7]u16{ 0, 4, 8, 12, 16, 20, 24 };
const offsets_2 = [7]u16{ 72, 76, 80, 84, 88, 92, 96 };
const offsets_3 = [7]u16{ 100, 104, 108, 112, 116, 120, 124 };
const offsets_4 = [7]u16{ 128, 132, 136, 140, 144, 148, 152 };
const offsets_5 = [7]u16{ 180, 184, 188, 192, 196, 200, 204 };
