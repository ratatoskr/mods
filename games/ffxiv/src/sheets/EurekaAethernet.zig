//! `EurekaAethernet`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Location`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EurekaAethernet = @This();

pub const sheet_name = "EurekaAethernet";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd870e208;
pub const Sheet = excel.Typed(EurekaAethernet);

row: excel.Row,

/// Links to `PlaceName`.
pub fn location(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, 0));
}
