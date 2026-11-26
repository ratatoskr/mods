//! `BehaviorPath`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BehaviorPath = @This();

pub const sheet_name = "BehaviorPath";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x96572d0d;
pub const Sheet = excel.Typed(BehaviorPath);

row: excel.Row,

pub fn speed(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn isTurnTransition(self: @This()) bool {
    return self.row.bitAt(4, 0);
}

pub fn isFadeOut(self: @This()) bool {
    return self.row.bitAt(4, 1);
}

pub fn isFadeIn(self: @This()) bool {
    return self.row.bitAt(4, 2);
}

pub fn isWalking(self: @This()) bool {
    return self.row.bitAt(4, 3);
}

pub fn unknown0(self: @This()) bool {
    return self.row.bitAt(4, 4);
}
