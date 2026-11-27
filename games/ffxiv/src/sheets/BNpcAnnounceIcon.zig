//! `BNpcAnnounceIcon`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Icon`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BNpcAnnounceIcon = @This();

pub const sheet_name = "BNpcAnnounceIcon";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdbf43666;
pub const Sheet = excel.Typed(BNpcAnnounceIcon);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{"Icon"};

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 0);
}
