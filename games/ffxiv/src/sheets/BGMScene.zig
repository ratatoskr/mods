//! `BGMScene`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BGMScene = @This();

pub const sheet_name = "BGMScene";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x2711a5ea;
pub const Sheet = excel.Typed(BGMScene);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "EnableDisableRestart", "Resume", "EnablePassEnd", "ForceAutoReset", "IgnoreBattle" };

pub fn enableDisableRestart(self: @This()) bool {
    return self.row.bitAt(0, 0);
}

pub fn @"resume"(self: @This()) bool {
    return self.row.bitAt(0, 1);
}

pub fn enablePassEnd(self: @This()) bool {
    return self.row.bitAt(0, 2);
}

pub fn forceAutoReset(self: @This()) bool {
    return self.row.bitAt(0, 3);
}

pub fn ignoreBattle(self: @This()) bool {
    return self.row.bitAt(0, 4);
}
