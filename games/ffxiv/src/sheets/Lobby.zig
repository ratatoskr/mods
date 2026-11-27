//! `Lobby`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Text`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Lobby = @This();

pub const sheet_name = "Lobby";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x54075f2e;
pub const Sheet = excel.Typed(Lobby);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "TYPE", "PARAM", "LINK", "Text", "Unknown0", "Unknown1" };

pub fn text(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown1(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn @"type"(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn param(self: @This()) u32 {
    return self.row.at(u32, 16);
}

pub fn link(self: @This()) u32 {
    return self.row.at(u32, 20);
}
