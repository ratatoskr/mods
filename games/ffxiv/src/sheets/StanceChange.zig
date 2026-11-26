//! `StanceChange`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const StanceChange = @This();

pub const sheet_name = "StanceChange";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf31cad82;
pub const Sheet = excel.Typed(StanceChange);

row: excel.Row,

pub fn unknown0(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub const action_len = 2;
/// Links to `Action`.
pub fn action(self: @This(), n0: usize) excel.Link(sheets.Action) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 10);
}

const offsets_1 = [2]u16{ 6, 8 };
