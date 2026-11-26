//! `KTGTypeWordTextData`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const KTGTypeWordTextData = @This();

pub const sheet_name = "KTGTypeWordTextData";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x9db0e48f;
pub const Sheet = excel.Typed(KTGTypeWordTextData);

row: excel.Row,

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) []const u8 {
    return self.row.stringAt(4);
}
