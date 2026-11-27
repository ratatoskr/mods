//! `OnlineStatus`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const OnlineStatus = @This();

pub const sheet_name = "OnlineStatus";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xbcffd5d8;
pub const Sheet = excel.Typed(OnlineStatus);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown1", "List", "Unknown2", "Priority", "Icon", "TextIcon", "Name" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// Links to `Addon`.
pub fn textIcon(self: @This()) excel.Link(sheets.Addon) {
    return .of(self.row.at(i32, 8));
}

pub fn priority(self: @This()) u8 {
    return self.row.at(u8, 12);
}

pub fn unknown1(self: @This()) bool {
    return self.row.bitAt(13, 0);
}

pub fn list(self: @This()) bool {
    return self.row.bitAt(13, 1);
}

pub fn unknown2(self: @This()) bool {
    return self.row.bitAt(13, 2);
}
