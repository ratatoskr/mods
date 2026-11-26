//! `PresetCameraAdjust`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PresetCameraAdjust = @This();

pub const sheet_name = "PresetCameraAdjust";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x98f7487e;
pub const Sheet = excel.Typed(PresetCameraAdjust);

row: excel.Row,

pub fn hyur_M(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn hyur_F(self: @This()) f32 {
    return self.row.at(f32, 4);
}

pub fn elezen_M(self: @This()) f32 {
    return self.row.at(f32, 8);
}

pub fn elezen_F(self: @This()) f32 {
    return self.row.at(f32, 12);
}

pub fn lalafell_M(self: @This()) f32 {
    return self.row.at(f32, 16);
}

pub fn lalafell_F(self: @This()) f32 {
    return self.row.at(f32, 20);
}

pub fn miqote_M(self: @This()) f32 {
    return self.row.at(f32, 24);
}

pub fn miqote_F(self: @This()) f32 {
    return self.row.at(f32, 28);
}

pub fn roe_M(self: @This()) f32 {
    return self.row.at(f32, 32);
}

pub fn roe_F(self: @This()) f32 {
    return self.row.at(f32, 36);
}

pub fn hrothgar_M(self: @This()) f32 {
    return self.row.at(f32, 40);
}

pub fn hrothgar_F(self: @This()) f32 {
    return self.row.at(f32, 44);
}

pub fn viera_M(self: @This()) f32 {
    return self.row.at(f32, 48);
}

pub fn viera_F(self: @This()) f32 {
    return self.row.at(f32, 52);
}

pub fn unknown_70(self: @This()) f32 {
    return self.row.at(f32, 56);
}

pub fn unknown0(self: @This()) f32 {
    return self.row.at(f32, 60);
}
