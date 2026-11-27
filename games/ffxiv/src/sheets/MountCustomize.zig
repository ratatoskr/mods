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

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown4", "Scale[0]", "Scale[1]", "Scale[2]", "Scale[3]", "Scale[4]", "Scale[5]", "Scale[6]", "Scale[7]", "Scale[8]", "Scale[9]", "Scale[10]", "Scale[11]", "Scale[12]", "Scale[13]", "Scale[14]", "Scale[15]", "Scale[16]", "Scale[17]", "Scale[18]", "Scale[19]", "Scale[20]", "CameraHeight[0]", "CameraHeight[1]", "CameraHeight[2]", "CameraHeight[3]", "CameraHeight[4]", "CameraHeight[5]", "CameraHeight[6]", "CameraHeight[7]", "CameraHeight[8]", "CameraHeight[9]", "CameraHeight[10]", "CameraHeight[11]", "CameraHeight[12]", "CameraHeight[13]", "CameraHeight[14]", "CameraHeight[15]", "CameraHeight[16]", "CameraHeight[17]", "CameraHeight[18]", "CameraHeight[19]", "CameraHeight[20]" };

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
