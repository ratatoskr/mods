//! `GimmickRect`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GimmickRect = @This();

pub const sheet_name = "GimmickRect";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x9be6d434;
pub const Sheet = excel.Typed(GimmickRect);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "LayoutID", "TriggerIn", "Params[0]", "Params[1]", "Params[2]", "Params[3]", "TriggerOut", "Params[4]", "Params[5]", "Params[6]", "Params[7]" };

/// The EventRange to associate with.
pub fn layoutID(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub const params_len = 8;
pub fn params(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_1[n0]);
}

/// 8 = Jump
pub fn triggerIn(self: @This()) u8 {
    return self.row.at(u8, 36);
}

pub fn triggerOut(self: @This()) u8 {
    return self.row.at(u8, 37);
}

const offsets_1 = [8]u16{ 4, 8, 12, 16, 20, 24, 28, 32 };
