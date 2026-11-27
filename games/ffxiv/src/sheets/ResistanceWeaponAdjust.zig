//! `ResistanceWeaponAdjust`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ResistanceWeaponAdjust = @This();

pub const sheet_name = "ResistanceWeaponAdjust";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x8fc095f4;
pub const Sheet = excel.Typed(ResistanceWeaponAdjust);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "MaxTotalStats", "MaxEachStat", "BaseParam[0]", "BaseParam[1]", "BaseParam[2]", "BaseParam[3]", "Image", "Unknown0" };

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn image(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn maxTotalStats(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn maxEachStat(self: @This()) u16 {
    return self.row.at(u16, 6);
}

pub const base_param_len = 4;
/// Links to `BaseParam`.
pub fn baseParam(self: @This(), n0: usize) excel.Link(sheets.BaseParam) {
    return .of(self.row.at(u8, offsets_1[n0]));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 12);
}

const offsets_1 = [4]u16{ 8, 9, 10, 11 };
