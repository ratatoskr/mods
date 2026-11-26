//! `SwitchTalkVariation`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Quest0`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SwitchTalkVariation = @This();

pub const sheet_name = "SwitchTalkVariation";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x031e9614;
pub const Sheet = excel.Typed(SwitchTalkVariation);

row: excel.Row,

/// Links to `Quest`.
pub fn quest0(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 0));
}

/// Links to `Quest`.
pub fn quest1(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 4));
}

/// Links to `DefaultTalk`.
pub fn defaultTalk(self: @This()) excel.Link(sheets.DefaultTalk) {
    return .of(self.row.at(u32, 8));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 12);
}
