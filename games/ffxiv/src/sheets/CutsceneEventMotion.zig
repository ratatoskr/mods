//! `CutsceneEventMotion`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CutsceneEventMotion = @This();

pub const sheet_name = "CutsceneEventMotion";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x025adb1e;
pub const Sheet = excel.Typed(CutsceneEventMotion);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown13", "Unknown12", "Unknown0", "Unknown1", "Unknown2", "Unknown3", "Unknown4", "Unknown5", "Unknown6", "Unknown7", "Unknown8", "Unknown9", "Unknown10", "Unknown11" };

pub fn unknown0(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn unknown1(self: @This()) f32 {
    return self.row.at(f32, 4);
}

pub fn unknown2(self: @This()) f32 {
    return self.row.at(f32, 8);
}

pub fn unknown3(self: @This()) f32 {
    return self.row.at(f32, 12);
}

pub fn unknown4(self: @This()) f32 {
    return self.row.at(f32, 16);
}

pub fn unknown5(self: @This()) f32 {
    return self.row.at(f32, 20);
}

pub fn unknown6(self: @This()) f32 {
    return self.row.at(f32, 24);
}

pub fn unknown7(self: @This()) f32 {
    return self.row.at(f32, 28);
}

pub fn unknown8(self: @This()) f32 {
    return self.row.at(f32, 32);
}

pub fn unknown9(self: @This()) f32 {
    return self.row.at(f32, 36);
}

pub fn unknown10(self: @This()) f32 {
    return self.row.at(f32, 40);
}

pub fn unknown11(self: @This()) f32 {
    return self.row.at(f32, 44);
}

pub fn unknown12(self: @This()) u16 {
    return self.row.at(u16, 48);
}

pub fn unknown13(self: @This()) u8 {
    return self.row.at(u8, 50);
}
