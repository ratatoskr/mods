//! `MountCustomize`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MountCustomize = @This();

pub const sheet_name = "MountCustomize";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x525def92;
pub const Sheet = excel.Typed(MountCustomize);

row: excel.Row,

pub const scale_len = 21;
pub fn scale(self: @This(), n0: usize) u16 {
    return self.row.at(u16, offsets_1[n0]);
}

pub const camera_height_len = 21;
pub fn cameraHeight(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_2[n0]);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(63, 0);
}

const offsets_1 = [21]u16{ 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40 };
const offsets_2 = [21]u16{ 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62 };
