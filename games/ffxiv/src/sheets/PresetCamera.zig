//! `PresetCamera`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PresetCamera = @This();

pub const sheet_name = "PresetCamera";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x38cdbc61;
pub const Sheet = excel.Typed(PresetCamera);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "EID", "PosX", "PosY", "PosZ", "Elezen", "Lalafell", "Miqote", "Roe", "Hrothgar", "Viera", "Unknown0", "Hyur_F", "Elezen_F", "Lalafell_F", "Miqote_F", "Roe_F", "Hrothgar_F", "Viera_F", "Unknown_70" };

pub fn posX(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn posY(self: @This()) f32 {
    return self.row.at(f32, 4);
}

pub fn posZ(self: @This()) f32 {
    return self.row.at(f32, 8);
}

pub fn elezen(self: @This()) f32 {
    return self.row.at(f32, 12);
}

pub fn lalafell(self: @This()) f32 {
    return self.row.at(f32, 16);
}

pub fn miqote(self: @This()) f32 {
    return self.row.at(f32, 20);
}

pub fn roe(self: @This()) f32 {
    return self.row.at(f32, 24);
}

pub fn hrothgar(self: @This()) f32 {
    return self.row.at(f32, 28);
}

pub fn viera(self: @This()) f32 {
    return self.row.at(f32, 32);
}

pub fn unknown0(self: @This()) f32 {
    return self.row.at(f32, 36);
}

pub fn hyur_F(self: @This()) f32 {
    return self.row.at(f32, 40);
}

pub fn elezen_F(self: @This()) f32 {
    return self.row.at(f32, 44);
}

pub fn lalafell_F(self: @This()) f32 {
    return self.row.at(f32, 48);
}

pub fn miqote_F(self: @This()) f32 {
    return self.row.at(f32, 52);
}

pub fn roe_F(self: @This()) f32 {
    return self.row.at(f32, 56);
}

pub fn hrothgar_F(self: @This()) f32 {
    return self.row.at(f32, 60);
}

pub fn viera_F(self: @This()) f32 {
    return self.row.at(f32, 64);
}

pub fn unknown_70(self: @This()) f32 {
    return self.row.at(f32, 68);
}

pub fn eid(self: @This()) u16 {
    return self.row.at(u16, 72);
}
