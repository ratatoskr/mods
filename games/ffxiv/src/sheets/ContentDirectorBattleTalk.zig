//! `ContentDirectorBattleTalk`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Text`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ContentDirectorBattleTalk = @This();

pub const sheet_name = "ContentDirectorBattleTalk";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xdfa0bec7;
pub const Sheet = excel.Typed(ContentDirectorBattleTalk);

row: excel.Row,

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn voLine(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// Links to `InstanceContentTextData`.
pub fn text(self: @This()) excel.Link(sheets.InstanceContentTextData) {
    return .of(self.row.at(u16, 8));
}

pub fn duration(self: @This()) u8 {
    return self.row.at(u8, 10);
}

pub fn style(self: @This()) u8 {
    return self.row.at(u8, 11);
}
