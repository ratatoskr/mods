//! `GatheringLeveBNpcEntry`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GatheringLeveBNpcEntry = @This();

pub const sheet_name = "GatheringLeveBNpcEntry";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x730863bd;
pub const Sheet = excel.Typed(GatheringLeveBNpcEntry);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown1", "Unknown4", "Unknown7", "Unknown10", "Unknown2", "Unknown5", "Unknown8", "Unknown11", "Unknown0", "Unknown3", "Unknown6", "Unknown9" };

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown1(self: @This()) i32 {
    return self.row.at(i32, 4);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn unknown3(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn unknown4(self: @This()) i32 {
    return self.row.at(i32, 16);
}

pub fn unknown5(self: @This()) u16 {
    return self.row.at(u16, 20);
}

pub fn unknown6(self: @This()) u32 {
    return self.row.at(u32, 24);
}

pub fn unknown7(self: @This()) i32 {
    return self.row.at(i32, 28);
}

pub fn unknown8(self: @This()) u16 {
    return self.row.at(u16, 32);
}

pub fn unknown9(self: @This()) u32 {
    return self.row.at(u32, 36);
}

pub fn unknown10(self: @This()) i32 {
    return self.row.at(i32, 40);
}

pub fn unknown11(self: @This()) u16 {
    return self.row.at(u16, 44);
}
