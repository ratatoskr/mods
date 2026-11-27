//! `CSBonusMission`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CSBonusMission = @This();

pub const sheet_name = "CSBonusMission";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x2020acf6;
pub const Sheet = excel.Typed(CSBonusMission);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Content0", "Content1" };

/// Links to `CSBonusContent`.
pub fn content0(self: @This()) excel.Link(sheets.CSBonusContent) {
    return .of(self.row.at(u16, 0));
}

/// Links to `CSBonusContent`.
pub fn content1(self: @This()) excel.Link(sheets.CSBonusContent) {
    return .of(self.row.at(u16, 2));
}
