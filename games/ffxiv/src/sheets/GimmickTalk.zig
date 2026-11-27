//! `GimmickTalk`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Message`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GimmickTalk = @This();

pub const sheet_name = "GimmickTalk";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x7a8258f0;
pub const Sheet = excel.Typed(GimmickTalk);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown1", "Unknown2", "Message" };

pub fn message(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn unknown2(self: @This()) bool {
    return self.row.bitAt(5, 0);
}
