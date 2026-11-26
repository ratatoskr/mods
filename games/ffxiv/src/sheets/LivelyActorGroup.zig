//! `LivelyActorGroup`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const LivelyActorGroup = @This();

pub const sheet_name = "LivelyActorGroup";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xc8ec8dc5;
pub const Sheet = excel.Typed(LivelyActorGroup);

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

pub fn unknown4(self: @This()) u32 {
    return self.row.at(u32, 16);
}

pub fn unknown5(self: @This()) u16 {
    return self.row.at(u16, 20);
}
