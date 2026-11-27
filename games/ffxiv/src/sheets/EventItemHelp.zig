//! `EventItemHelp`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Description`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EventItemHelp = @This();

pub const sheet_name = "EventItemHelp";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x8e477c70;
pub const Sheet = excel.Typed(EventItemHelp);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Description", "Unknown0" };

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown0(self: @This()) bool {
    return self.row.bitAt(4, 0);
}
