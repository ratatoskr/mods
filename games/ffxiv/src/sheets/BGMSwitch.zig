//! `BGMSwitch`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BGMSwitch = @This();

pub const sheet_name = "BGMSwitch";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x0989d4f2;
pub const Sheet = excel.Typed(BGMSwitch);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "BGMSystemDefine", "Quest", "Unknown0", "BGM" };

/// Links to `Quest`.
pub fn quest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 0));
}

/// Links to `BGM` or `BGMSituation`, whichever has the row.
pub fn bgm(self: @This()) u16 {
    return self.row.at(u16, 4);
}

/// Links to `BGMSystemDefine`.
pub fn bgmSystemDefine(self: @This()) excel.Link(sheets.BGMSystemDefine) {
    return .of(self.row.at(u8, 6));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 7);
}
