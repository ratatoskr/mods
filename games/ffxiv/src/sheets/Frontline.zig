//! `Frontline`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Frontline = @This();

pub const sheet_name = "Frontline";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd98c012d;
pub const Sheet = excel.Typed(Frontline);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown3", "Unknown4", "Unknown5", "Unknown6", "Unknown7", "Unknown8", "Unknown9", "Unknown10", "Unknown11", "Unknown12", "Unknown13", "Unknown14", "Unknown15", "Unknown16", "Unknown17", "Unknown18", "Unknown19", "Unknown20", "Unknown21", "Unknown22", "Unknown0", "Unknown1", "Unknown2" };

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unknown2(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn unknown3(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn unknown4(self: @This()) u16 {
    return self.row.at(u16, 14);
}

pub fn unknown5(self: @This()) u16 {
    return self.row.at(u16, 16);
}

pub fn unknown6(self: @This()) u16 {
    return self.row.at(u16, 18);
}

pub fn unknown7(self: @This()) u16 {
    return self.row.at(u16, 20);
}

pub fn unknown8(self: @This()) u16 {
    return self.row.at(u16, 22);
}

pub fn unknown9(self: @This()) u16 {
    return self.row.at(u16, 24);
}

pub fn unknown10(self: @This()) u16 {
    return self.row.at(u16, 26);
}

pub fn unknown11(self: @This()) u16 {
    return self.row.at(u16, 28);
}

pub fn unknown12(self: @This()) u16 {
    return self.row.at(u16, 30);
}

pub fn unknown13(self: @This()) u16 {
    return self.row.at(u16, 32);
}

pub fn unknown14(self: @This()) u16 {
    return self.row.at(u16, 34);
}

pub fn unknown15(self: @This()) u16 {
    return self.row.at(u16, 36);
}

pub fn unknown16(self: @This()) u16 {
    return self.row.at(u16, 38);
}

pub fn unknown17(self: @This()) u16 {
    return self.row.at(u16, 40);
}

pub fn unknown18(self: @This()) u16 {
    return self.row.at(u16, 42);
}

pub fn unknown19(self: @This()) u16 {
    return self.row.at(u16, 44);
}

pub fn unknown20(self: @This()) u16 {
    return self.row.at(u16, 46);
}

pub fn unknown21(self: @This()) u16 {
    return self.row.at(u16, 48);
}

pub fn unknown22(self: @This()) u16 {
    return self.row.at(u16, 50);
}
