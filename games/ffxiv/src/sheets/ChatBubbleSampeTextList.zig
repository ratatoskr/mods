//! `ChatBubbleSampeTextList`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ChatBubbleSampeTextList = @This();

pub const sheet_name = "ChatBubbleSampeTextList";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xcd4cb81c;
pub const Sheet = excel.Typed(ChatBubbleSampeTextList);

row: excel.Row,

pub fn unknown0(self: @This()) bool {
    return self.row.bitAt(0, 0);
}
