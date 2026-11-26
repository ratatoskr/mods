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
