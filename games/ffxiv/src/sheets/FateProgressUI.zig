//! `FateProgressUI`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Location`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const FateProgressUI = @This();

pub const sheet_name = "FateProgressUI";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xbccd5130;
pub const Sheet = excel.Typed(FateProgressUI);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Location", "ReqFatesToRank2", "ReqFatesToRank3", "ReqFatesToRank4", "Unknown0", "DisplayOrder" };

/// Links to `TerritoryType`.
pub fn location(self: @This()) excel.Link(sheets.TerritoryType) {
    return .of(self.row.at(i32, 0));
}

pub fn reqFatesToRank2(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn reqFatesToRank3(self: @This()) u8 {
    return self.row.at(u8, 5);
}

pub fn reqFatesToRank4(self: @This()) u8 {
    return self.row.at(u8, 6);
}

pub fn displayOrder(self: @This()) u8 {
    return self.row.at(u8, 7);
}

pub fn unknown0(self: @This()) i8 {
    return self.row.at(i8, 8);
}
