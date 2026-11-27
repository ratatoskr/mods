//! `AnimationLOD`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AnimationLOD = @This();

pub const sheet_name = "AnimationLOD";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x261cfad0;
pub const Sheet = excel.Typed(AnimationLOD);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "CameraDistance", "SampleInterval", "BoneLOD", "AnimationEnable[0]", "AnimationEnable[1]", "AnimationEnable[2]", "AnimationEnable[3]", "AnimationEnable[4]", "AnimationEnable[5]", "AnimationEnable[6]", "AnimationEnable[7]" };

pub fn cameraDistance(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn sampleInterval(self: @This()) f32 {
    return self.row.at(f32, 4);
}

pub fn boneLOD(self: @This()) i8 {
    return self.row.at(i8, 8);
}

pub const animation_enable_len = 8;
pub fn animationEnable(self: @This(), n0: usize) bool {
    return self.row.at(u8, offsets_1[n0]) != 0;
}

const offsets_1 = [8]u16{ 9, 10, 11, 12, 13, 14, 15, 16 };
