//! `WeddingPlan`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WeddingPlan = @This();

pub const sheet_name = "WeddingPlan";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x6ceafe59;
pub const Sheet = excel.Typed(WeddingPlan);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Unknown1", "Unknown2", "Unknown3", "Unknown4", "Unknown5", "Unknown6", "Unknown7", "Unknown8", "Unknown9", "Unknown10", "Unknown11", "Unknown12", "Unknown13", "Unknown14", "Unknown15", "Unknown16", "Unknown17", "Unknown18", "Unknown19" };

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 0);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 1);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 2);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 3);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 5);
}

pub fn unknown6(self: @This()) u8 {
    return self.row.at(u8, 6);
}

pub fn unknown7(self: @This()) u8 {
    return self.row.at(u8, 7);
}

pub fn unknown8(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn unknown9(self: @This()) u8 {
    return self.row.at(u8, 9);
}

pub fn unknown10(self: @This()) u8 {
    return self.row.at(u8, 10);
}

pub fn unknown11(self: @This()) u8 {
    return self.row.at(u8, 11);
}

pub fn unknown12(self: @This()) u8 {
    return self.row.at(u8, 12);
}

pub fn unknown13(self: @This()) u8 {
    return self.row.at(u8, 13);
}

pub fn unknown14(self: @This()) u8 {
    return self.row.at(u8, 14);
}

pub fn unknown15(self: @This()) u8 {
    return self.row.at(u8, 15);
}

pub fn unknown16(self: @This()) u8 {
    return self.row.at(u8, 16);
}

pub fn unknown17(self: @This()) u8 {
    return self.row.at(u8, 17);
}

pub fn unknown18(self: @This()) u8 {
    return self.row.at(u8, 18);
}

pub fn unknown19(self: @This()) u8 {
    return self.row.at(u8, 19);
}
