//! `PhysicsParameter`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PhysicsParameter = @This();

pub const sheet_name = "PhysicsParameter";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe018b5fa;
pub const Sheet = excel.Typed(PhysicsParameter);

row: excel.Row,

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
