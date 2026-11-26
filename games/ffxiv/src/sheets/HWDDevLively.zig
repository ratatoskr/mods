//! `HWDDevLively`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `ENPC`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HWDDevLively = @This();

pub const sheet_name = "HWDDevLively";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xe18cbe18;
pub const Sheet = excel.Typed(HWDDevLively);

row: excel.Row,

/// Links to `ENpcBase`.
pub fn enpc(self: @This()) excel.Link(sheets.ENpcBase) {
    return .of(self.row.at(u32, 0));
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 6);
}
