//! `CompanyAction`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CompanyAction = @This();

pub const sheet_name = "CompanyAction";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xde0dd9cf;
pub const Sheet = excel.Typed(CompanyAction);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn cost(self: @This()) u32 {
    return self.row.at(u32, 8);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 12);
}

/// Links to `FCRank`.
pub fn fcRank(self: @This()) excel.Link(sheets.FCRank) {
    return .of(self.row.at(u8, 16));
}

pub fn order(self: @This()) u8 {
    return self.row.at(u8, 17);
}

pub fn purchasable(self: @This()) bool {
    return self.row.bitAt(18, 0);
}
