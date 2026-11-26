//! `WKSAetheryte`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSAetheryte = @This();

pub const sheet_name = "WKSAetheryte";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5a516458;
pub const Sheet = excel.Typed(WKSAetheryte);

row: excel.Row,

/// Links to `PlaceName`.
pub fn name(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u32, 0));
}

/// Links to `WKSAetheryteObjectGroup`.
pub fn objectGroup(self: @This()) excel.Link(sheets.WKSAetheryteObjectGroup) {
    return .of(self.row.at(u8, 4));
}
