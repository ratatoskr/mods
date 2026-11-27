//! `Resident`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Resident = @This();

pub const sheet_name = "Resident";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x9af0b586;
pub const Sheet = excel.Typed(Resident);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown1", "Model", "NpcYell", "Unknown0", "ResidentMotionType" };

pub fn model(self: @This()) u64 {
    return self.row.at(u64, 0);
}

/// Links to `NpcYell`.
pub fn npcYell(self: @This()) excel.Link(sheets.NpcYell) {
    return .of(self.row.at(i32, 8));
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 14);
}

/// Links to `ResidentMotionType`.
pub fn residentMotionType(self: @This()) excel.Link(sheets.ResidentMotionType) {
    return .of(self.row.at(u8, 15));
}
