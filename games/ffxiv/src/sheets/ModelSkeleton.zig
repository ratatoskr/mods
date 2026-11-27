//! `ModelSkeleton`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ModelSkeleton = @This();

pub const sheet_name = "ModelSkeleton";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x94cc54f1;
pub const Sheet = excel.Typed(ModelSkeleton);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Radius", "Height", "VFXScale", "Unknown0", "Unknown1", "Unknown2", "Unknown3", "Unknown4", "Unknown5", "Unknown6", "Unknown7", "FloatHeight", "FloatDown", "FloatUp", "Unknown8", "MotionBlendType", "LoopFlySE" };

pub fn radius(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn height(self: @This()) f32 {
    return self.row.at(f32, 4);
}

pub fn vfxScale(self: @This()) f32 {
    return self.row.at(f32, 8);
}

pub fn floatHeight(self: @This()) f32 {
    return self.row.at(f32, 12);
}

pub fn floatDown(self: @This()) f32 {
    return self.row.at(f32, 16);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 20);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 22);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 24);
}

pub fn unknown3(self: @This()) u16 {
    return self.row.at(u16, 26);
}

pub fn unknown4(self: @This()) u16 {
    return self.row.at(u16, 28);
}

pub fn unknown5(self: @This()) u16 {
    return self.row.at(u16, 30);
}

pub fn unknown6(self: @This()) u16 {
    return self.row.at(u16, 32);
}

pub fn unknown7(self: @This()) u16 {
    return self.row.at(u16, 34);
}

pub fn floatUp(self: @This()) u16 {
    return self.row.at(u16, 36);
}

pub fn unknown8(self: @This()) u8 {
    return self.row.at(u8, 38);
}

pub fn loopFlySE(self: @This()) u8 {
    return self.row.at(u8, 39);
}

pub fn motionBlendType(self: @This()) bool {
    return self.row.bitAt(40, 0);
}
