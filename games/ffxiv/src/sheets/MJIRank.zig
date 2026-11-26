//! `MJIRank`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJIRank = @This();

pub const sheet_name = "MJIRank";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x929748f4;
pub const Sheet = excel.Typed(MJIRank);

row: excel.Row,

pub fn expToNext(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub const log_message_len = 3;
/// Links to `LogMessage`.
pub fn logMessage(self: @This(), n0: usize) excel.Link(sheets.LogMessage) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 16);
}

const offsets_1 = [3]u16{ 4, 8, 12 };
