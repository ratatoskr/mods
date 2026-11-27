//! `MiniGameTurnBreakPop`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MiniGameTurnBreakPop = @This();

pub const sheet_name = "MiniGameTurnBreakPop";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x00a94fea;
pub const Sheet = excel.Typed(MiniGameTurnBreakPop);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown1", "Unknown2", "Unknown3", "Unknown0" };

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 2);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 3);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 4);
}
