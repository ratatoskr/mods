//! `TextCommand`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Command`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TextCommand = @This();

pub const sheet_name = "TextCommand";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5d4b4e4b;
pub const Sheet = excel.Typed(TextCommand);

row: excel.Row,

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn alias(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn shortAlias(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn command(self: @This()) []const u8 {
    return self.row.stringAt(12);
}

pub fn shortCommand(self: @This()) []const u8 {
    return self.row.stringAt(16);
}

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 20);
}

/// Links to `TextCommandParam`.
pub fn param(self: @This()) excel.Link(sheets.TextCommandParam) {
    return .of(self.row.at(u16, 24));
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 26);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 27);
}

pub fn unknown3(self: @This()) i8 {
    return self.row.at(i8, 28);
}

pub fn unknown4(self: @This()) i8 {
    return self.row.at(i8, 29);
}

pub fn unknown5(self: @This()) i8 {
    return self.row.at(i8, 30);
}
