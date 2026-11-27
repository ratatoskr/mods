//! `Frontline02`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Frontline02 = @This();

pub const sheet_name = "Frontline02";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x4d1b9359;
pub const Sheet = excel.Typed(Frontline02);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown9", "Unknown10", "Unknown11", "Unknown12", "Unknown13", "Unknown14", "Unknown15", "Unknown16", "Unknown17", "Unknown18", "Unknown19", "Unknown20", "Unknown21", "Unknown22", "Unknown23", "Unknown24", "Unknown25", "Unknown26", "Unknown27", "Unknown28", "Unknown29", "Unknown0", "Unknown1", "Unknown2", "Unknown3", "Unknown4", "Unknown5", "Unknown6", "Unknown7", "Unknown8" };

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unknown2(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn unknown3(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn unknown4(self: @This()) u32 {
    return self.row.at(u32, 16);
}

pub fn unknown5(self: @This()) u32 {
    return self.row.at(u32, 20);
}

pub fn unknown6(self: @This()) u32 {
    return self.row.at(u32, 24);
}

pub fn unknown7(self: @This()) u32 {
    return self.row.at(u32, 28);
}

pub fn unknown8(self: @This()) u32 {
    return self.row.at(u32, 32);
}

pub fn unknown9(self: @This()) u16 {
    return self.row.at(u16, 36);
}

pub fn unknown10(self: @This()) u16 {
    return self.row.at(u16, 38);
}

pub fn unknown11(self: @This()) u16 {
    return self.row.at(u16, 40);
}

pub fn unknown12(self: @This()) u16 {
    return self.row.at(u16, 42);
}

pub fn unknown13(self: @This()) u16 {
    return self.row.at(u16, 44);
}

pub fn unknown14(self: @This()) u16 {
    return self.row.at(u16, 46);
}

pub fn unknown15(self: @This()) u16 {
    return self.row.at(u16, 48);
}

pub fn unknown16(self: @This()) u16 {
    return self.row.at(u16, 50);
}

pub fn unknown17(self: @This()) u16 {
    return self.row.at(u16, 52);
}

pub fn unknown18(self: @This()) u16 {
    return self.row.at(u16, 54);
}

pub fn unknown19(self: @This()) u16 {
    return self.row.at(u16, 56);
}

pub fn unknown20(self: @This()) u16 {
    return self.row.at(u16, 58);
}

pub fn unknown21(self: @This()) u16 {
    return self.row.at(u16, 60);
}

pub fn unknown22(self: @This()) u16 {
    return self.row.at(u16, 62);
}

pub fn unknown23(self: @This()) u16 {
    return self.row.at(u16, 64);
}

pub fn unknown24(self: @This()) u16 {
    return self.row.at(u16, 66);
}

pub fn unknown25(self: @This()) u16 {
    return self.row.at(u16, 68);
}

pub fn unknown26(self: @This()) u16 {
    return self.row.at(u16, 70);
}

pub fn unknown27(self: @This()) u16 {
    return self.row.at(u16, 72);
}

pub fn unknown28(self: @This()) u16 {
    return self.row.at(u16, 74);
}

pub fn unknown29(self: @This()) u16 {
    return self.row.at(u16, 76);
}
