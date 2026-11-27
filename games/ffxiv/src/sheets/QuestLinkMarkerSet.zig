//! `QuestLinkMarkerSet`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const QuestLinkMarkerSet = @This();

pub const sheet_name = "QuestLinkMarkerSet";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x202b96b0;
pub const Sheet = excel.Typed(QuestLinkMarkerSet);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown1", "Unknown0", "Unknown2", "Unknown3", "Unknown4", "Unknown5", "Unknown6" };

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 6);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 7);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn unknown5(self: @This()) bool {
    return self.row.bitAt(9, 0);
}

pub fn unknown6(self: @This()) bool {
    return self.row.bitAt(9, 1);
}
