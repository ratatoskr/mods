//! `CompanyLeveRule`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Type`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CompanyLeveRule = @This();

pub const sheet_name = "CompanyLeveRule";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xcc3ad729;
pub const Sheet = excel.Typed(CompanyLeveRule);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Type", "Objective", "Help" };

pub fn @"type"(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `LeveString`.
pub fn objective(self: @This()) excel.Link(sheets.LeveString) {
    return .of(self.row.at(u16, 4));
}

/// Links to `LeveString`.
pub fn help(self: @This()) excel.Link(sheets.LeveString) {
    return .of(self.row.at(u16, 6));
}
