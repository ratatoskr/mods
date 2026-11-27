//! `EventTutorialPage`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EventTutorialPage = @This();

pub const sheet_name = "EventTutorialPage";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x11a44a12;
pub const Sheet = excel.Typed(EventTutorialPage);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Image", "Name", "Text" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn text(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn image(self: @This()) u32 {
    return self.row.at(u32, 8);
}
