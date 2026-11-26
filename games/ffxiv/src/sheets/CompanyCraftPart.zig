//! `CompanyCraftPart`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CompanyCraftPart = @This();

pub const sheet_name = "CompanyCraftPart";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe9ffd316;
pub const Sheet = excel.Typed(CompanyCraftPart);

row: excel.Row,

pub const company_craft_process_len = 3;
/// Links to `CompanyCraftProcess`.
pub fn companyCraftProcess(self: @This(), n0: usize) excel.Link(sheets.CompanyCraftProcess) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 6);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 8);
}

/// Links to `CompanyCraftType`.
pub fn companyCraftType(self: @This()) excel.Link(sheets.CompanyCraftType) {
    return .of(self.row.at(u8, 9));
}

const offsets_1 = [3]u16{ 0, 2, 4 };
