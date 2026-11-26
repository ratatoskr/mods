//! `WKSAetheryteList`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSAetheryteList = @This();

pub const sheet_name = "WKSAetheryteList";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xdcfd9eba;
pub const Sheet = excel.Typed(WKSAetheryteList);

row: excel.Row,

/// Links to `WKSAetheryte`.
pub fn aetheryte(self: @This()) excel.Link(sheets.WKSAetheryte) {
    return .of(self.row.at(u8, 0));
}
