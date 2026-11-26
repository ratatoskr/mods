//! `EventSetDefine`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EventSetDefine = @This();

pub const sheet_name = "EventSetDefine";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x5bfa8a4e;
pub const Sheet = excel.Typed(EventSetDefine);

row: excel.Row,

/// Links to `Quest`.
pub fn unknown0(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 0));
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 4);
}
