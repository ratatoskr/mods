//! `MiniGameRANotes`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MiniGameRANotes = @This();

pub const sheet_name = "MiniGameRANotes";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xeed86d68;
pub const Sheet = excel.Typed(MiniGameRANotes);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Unknown4", "Unknown5", "Unknown6", "Unknown1", "Unknown2", "Unknown3" };

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown1(self: @This()) i32 {
    return self.row.at(i32, 4);
}

pub fn unknown2(self: @This()) i32 {
    return self.row.at(i32, 8);
}

pub fn unknown3(self: @This()) i32 {
    return self.row.at(i32, 12);
}

pub fn unknown4(self: @This()) u16 {
    return self.row.at(u16, 16);
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 18);
}

pub fn unknown6(self: @This()) u8 {
    return self.row.at(u8, 19);
}
