//! `GimmickYesNo`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Message`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GimmickYesNo = @This();

pub const sheet_name = "GimmickYesNo";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x7f711762;
pub const Sheet = excel.Typed(GimmickYesNo);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Message", "YesButton", "NoButton" };

pub fn message(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn yesButton(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn noButton(self: @This()) []const u8 {
    return self.row.stringAt(8);
}
