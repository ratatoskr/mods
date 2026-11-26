//! `PhysicsWind`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PhysicsWind = @This();

pub const sheet_name = "PhysicsWind";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x3bc4120f;
pub const Sheet = excel.Typed(PhysicsWind);

row: excel.Row,

pub fn threshold(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn amplitude(self: @This()) f32 {
    return self.row.at(f32, 4);
}

pub fn amplitudeFrequency(self: @This()) f32 {
    return self.row.at(f32, 8);
}

pub fn powerMin(self: @This()) f32 {
    return self.row.at(f32, 12);
}

pub fn powerMax(self: @This()) f32 {
    return self.row.at(f32, 16);
}

pub fn powerFrequency(self: @This()) f32 {
    return self.row.at(f32, 20);
}
