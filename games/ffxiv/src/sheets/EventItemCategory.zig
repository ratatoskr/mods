//! `EventItemCategory`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EventItemCategory = @This();

pub const sheet_name = "EventItemCategory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xbf993f69;
pub const Sheet = excel.Typed(EventItemCategory);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Text", "ReceiveLogMessage", "DiscardLogMessage" };

pub fn text(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `LogMessage`.
pub fn receiveLogMessage(self: @This()) excel.Link(sheets.LogMessage) {
    return .of(self.row.at(u32, 4));
}

/// Links to `LogMessage`.
pub fn discardLogMessage(self: @This()) excel.Link(sheets.LogMessage) {
    return .of(self.row.at(u32, 8));
}
