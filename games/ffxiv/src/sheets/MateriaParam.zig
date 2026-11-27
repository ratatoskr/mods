//! `MateriaParam`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MateriaParam = @This();

pub const sheet_name = "MateriaParam";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf5bcbfdb;
pub const Sheet = excel.Typed(MateriaParam);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Unknown1", "Unknown15", "Unknown2", "Unknown3", "Unknown4", "Unknown5", "Unknown6", "Unknown7", "Unknown8", "Unknown9", "Unknown10", "Unknown11", "Unknown12", "Unknown13", "Unknown14" };

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 0);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 1);
}

pub fn unknown2(self: @This()) bool {
    return self.row.at(u8, 2) != 0;
}

pub fn unknown3(self: @This()) bool {
    return self.row.at(u8, 3) != 0;
}

pub fn unknown4(self: @This()) bool {
    return self.row.at(u8, 4) != 0;
}

pub fn unknown5(self: @This()) bool {
    return self.row.at(u8, 5) != 0;
}

pub fn unknown6(self: @This()) bool {
    return self.row.at(u8, 6) != 0;
}

pub fn unknown7(self: @This()) bool {
    return self.row.at(u8, 7) != 0;
}

pub fn unknown8(self: @This()) bool {
    return self.row.at(u8, 8) != 0;
}

pub fn unknown9(self: @This()) bool {
    return self.row.at(u8, 9) != 0;
}

pub fn unknown10(self: @This()) bool {
    return self.row.at(u8, 10) != 0;
}

pub fn unknown11(self: @This()) bool {
    return self.row.at(u8, 11) != 0;
}

pub fn unknown12(self: @This()) bool {
    return self.row.at(u8, 12) != 0;
}

pub fn unknown13(self: @This()) bool {
    return self.row.at(u8, 13) != 0;
}

pub fn unknown14(self: @This()) bool {
    return self.row.at(u8, 14) != 0;
}

pub fn unknown15(self: @This()) bool {
    return self.row.bitAt(15, 0);
}
