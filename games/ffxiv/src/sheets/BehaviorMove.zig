//! `BehaviorMove`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BehaviorMove = @This();

pub const sheet_name = "BehaviorMove";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x0c362f6e;
pub const Sheet = excel.Typed(BehaviorMove);

row: excel.Row,

pub fn unknown0(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn unknown2(self: @This()) bool {
    return self.row.bitAt(5, 0);
}

pub fn unknown3(self: @This()) bool {
    return self.row.bitAt(5, 1);
}
