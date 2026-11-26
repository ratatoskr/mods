//! `EventIconType`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EventIconType = @This();

pub const sheet_name = "EventIconType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x6ce9409c;
pub const Sheet = excel.Typed(EventIconType);

row: excel.Row,

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn npcIconAvailable(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn mapIconAvailable(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn npcIconInvalid(self: @This()) u32 {
    return self.row.at(u32, 8);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn mapIconInvalid(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn iconRange(self: @This()) u8 {
    return self.row.at(u8, 16);
}
