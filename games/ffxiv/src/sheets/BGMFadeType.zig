//! `BGMFadeType`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BGMFadeType = @This();

pub const sheet_name = "BGMFadeType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe018b5fa;
pub const Sheet = excel.Typed(BGMFadeType);

row: excel.Row,

pub fn fadeOutTime(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn fadeInTime(self: @This()) f32 {
    return self.row.at(f32, 4);
}

pub fn fadeInStartTime(self: @This()) f32 {
    return self.row.at(f32, 8);
}

pub fn resumeFadeInTime(self: @This()) f32 {
    return self.row.at(f32, 12);
}
