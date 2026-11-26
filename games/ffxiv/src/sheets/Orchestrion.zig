//! `Orchestrion`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Orchestrion = @This();

pub const sheet_name = "Orchestrion";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x9db0e48f;
pub const Sheet = excel.Typed(Orchestrion);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}
