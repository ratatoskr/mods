//! `WebGuidance`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WebGuidance = @This();

pub const sheet_name = "WebGuidance";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xa6cfe561;
pub const Sheet = excel.Typed(WebGuidance);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Image", "Url", "Name", "Unknown0", "Description" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn image(self: @This()) i32 {
    return self.row.at(i32, 12);
}

/// Links to `WebURL`.
pub fn url(self: @This()) excel.Link(sheets.WebURL) {
    return .of(self.row.at(u8, 16));
}
