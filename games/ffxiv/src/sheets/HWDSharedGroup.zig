//! `HWDSharedGroup`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `LGBSharedGroup`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HWDSharedGroup = @This();

pub const sheet_name = "HWDSharedGroup";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x5a516458;
pub const Sheet = excel.Typed(HWDSharedGroup);

row: excel.Row,

pub fn lgbSharedGroup(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// Links to `HWDSharedGroupControlParam`.
pub fn param(self: @This()) excel.Link(sheets.HWDSharedGroupControlParam) {
    return .of(self.row.at(u8, 4));
}
