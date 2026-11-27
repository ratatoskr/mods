//! `MJILivelyActor`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJILivelyActor = @This();

pub const sheet_name = "MJILivelyActor";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xc8ec8dc5;
pub const Sheet = excel.Typed(MJILivelyActor);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "ENPC", "Behavior", "X", "Y", "Z", "Rot" };

pub fn x(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn y(self: @This()) f32 {
    return self.row.at(f32, 4);
}

pub fn z(self: @This()) f32 {
    return self.row.at(f32, 8);
}

pub fn rot(self: @This()) f32 {
    return self.row.at(f32, 12);
}

/// Links to `ENpcResident`.
pub fn enpc(self: @This()) excel.Link(sheets.ENpcResident) {
    return .of(self.row.at(u32, 16));
}

/// Links to `Behavior`.
pub fn behavior(self: @This()) excel.Link(sheets.Behavior) {
    return .of(self.row.at(u16, 20));
}
