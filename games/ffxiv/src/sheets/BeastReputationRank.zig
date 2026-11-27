//! `BeastReputationRank`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BeastReputationRank = @This();

pub const sheet_name = "BeastReputationRank";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x446d8bad;
pub const Sheet = excel.Typed(BeastReputationRank);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "RequiredReputation", "Name", "AlliedNames", "Color" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn alliedNames(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

/// Links to `UIColor`.
pub fn color(self: @This()) excel.Link(sheets.UIColor) {
    return .of(self.row.at(u32, 8));
}

pub fn requiredReputation(self: @This()) u16 {
    return self.row.at(u16, 12);
}
