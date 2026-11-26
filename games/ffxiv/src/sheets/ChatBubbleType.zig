//! `ChatBubbleType`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ChatBubbleType = @This();

pub const sheet_name = "ChatBubbleType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x1026cfcf;
pub const Sheet = excel.Typed(ChatBubbleType);

row: excel.Row,

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown2(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn unknown3(self: @This()) []const u8 {
    return self.row.stringAt(12);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 16);
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 17);
}

pub fn unknown6(self: @This()) u8 {
    return self.row.at(u8, 18);
}
