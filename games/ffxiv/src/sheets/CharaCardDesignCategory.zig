//! `CharaCardDesignCategory`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CharaCardDesignCategory = @This();

pub const sheet_name = "CharaCardDesignCategory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5eb59ccb;
pub const Sheet = excel.Typed(CharaCardDesignCategory);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn sortKey(self: @This()) u8 {
    return self.row.at(u8, 4);
}
