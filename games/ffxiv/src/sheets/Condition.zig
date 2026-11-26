//! `Condition`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Condition = @This();

pub const sheet_name = "Condition";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf234a002;
pub const Sheet = excel.Typed(Condition);

row: excel.Row,

/// Links to `LogMessage`.
pub fn logMessage(self: @This()) excel.Link(sheets.LogMessage) {
    return .of(self.row.at(u32, 0));
}

/// Links to `Permission`.
pub fn permission(self: @This()) excel.Link(sheets.Permission) {
    return .of(self.row.at(u8, 4));
}

/// The lower this number is, the higher the priority. Used to determine which conditions LogMessage should be printed.
pub fn logMessagePriority(self: @This()) u8 {
    return self.row.at(u8, 5);
}

/// Allows this Condition to be set by a packet received from the server.
pub fn isNetworked(self: @This()) bool {
    return self.row.bitAt(6, 0);
}
