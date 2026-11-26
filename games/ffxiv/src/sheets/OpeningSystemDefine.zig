//! `OpeningSystemDefine`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Text`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const OpeningSystemDefine = @This();

pub const sheet_name = "OpeningSystemDefine";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x98fff20a;
pub const Sheet = excel.Typed(OpeningSystemDefine);

row: excel.Row,

pub fn text(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn defineValue(self: @This()) u32 {
    return self.row.at(u32, 4);
}
