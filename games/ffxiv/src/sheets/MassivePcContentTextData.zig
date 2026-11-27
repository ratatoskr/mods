//! `MassivePcContentTextData`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Text`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MassivePcContentTextData = @This();

pub const sheet_name = "MassivePcContentTextData";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdebb20e3;
pub const Sheet = excel.Typed(MassivePcContentTextData);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{"Text"};

pub fn text(self: @This()) []const u8 {
    return self.row.stringAt(0);
}
