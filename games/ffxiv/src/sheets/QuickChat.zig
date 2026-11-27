//! `QuickChat`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `NameAction`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const QuickChat = @This();

pub const sheet_name = "QuickChat";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x66d693c5;
pub const Sheet = excel.Typed(QuickChat);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "NameAction", "Icon", "Addon", "QuickChatTransient", "Unknown0" };

pub fn nameAction(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 4);
}

/// Links to `Addon`.
pub fn addon(self: @This()) excel.Link(sheets.Addon) {
    return .of(self.row.at(i32, 8));
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 12);
}

/// Links to `QuickChatTransient`.
pub fn quickChatTransient(self: @This()) excel.Link(sheets.QuickChatTransient) {
    return .of(self.row.at(i8, 14));
}
