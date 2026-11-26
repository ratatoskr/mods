//! `ContentEventItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `EventItem`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ContentEventItem = @This();

pub const sheet_name = "ContentEventItem";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xdbf43666;
pub const Sheet = excel.Typed(ContentEventItem);

row: excel.Row,

/// Links to `EventItem`.
pub fn eventItem(self: @This()) excel.Link(sheets.EventItem) {
    return .of(self.row.at(u32, 0));
}
