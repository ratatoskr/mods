//! `PvPAction`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Action`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PvPAction = @This();

pub const sheet_name = "PvPAction";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x3818ca1d;
pub const Sheet = excel.Typed(PvPAction);

row: excel.Row,

/// Links to `Action`.
pub fn action(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(u16, 0));
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 2);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 6);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 9);
}

pub const grand_company_len = 3;
pub fn grandCompany(self: @This(), n0: usize) bool {
    return self.row.at(u8, offsets_1[n0]) != 0;
}

const offsets_1 = [3]u16{ 10, 11, 12 };
