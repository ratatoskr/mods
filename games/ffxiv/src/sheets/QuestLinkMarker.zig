//! `QuestLinkMarker`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const QuestLinkMarker = @This();

pub const sheet_name = "QuestLinkMarker";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xea112ef0;
pub const Sheet = excel.Typed(QuestLinkMarker);

row: excel.Row,

/// Links to `Map`.
pub fn sourceMap(self: @This()) excel.Link(sheets.Map) {
    return .of(self.row.at(u32, 0));
}

/// Links to `Level`.
pub fn level(self: @This()) excel.Link(sheets.Level) {
    return .of(self.row.at(u32, 4));
}

/// Links to `Map`.
pub fn targetMap(self: @This()) excel.Link(sheets.Map) {
    return .of(self.row.at(u32, 8));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 12);
}

pub fn unknown1(self: @This()) bool {
    return self.row.bitAt(13, 0);
}
