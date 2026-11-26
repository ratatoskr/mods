//! `SkyIslandMapMarker`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SkyIslandMapMarker = @This();

pub const sheet_name = "SkyIslandMapMarker";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xa4e38464;
pub const Sheet = excel.Typed(SkyIslandMapMarker);

row: excel.Row,

pub fn unknown0(self: @This()) i16 {
    return self.row.at(i16, 0);
}

pub fn unknown1(self: @This()) i16 {
    return self.row.at(i16, 2);
}

pub fn unknown2(self: @This()) i16 {
    return self.row.at(i16, 4);
}

pub fn unknown3(self: @This()) i16 {
    return self.row.at(i16, 6);
}

pub fn unknown4(self: @This()) i16 {
    return self.row.at(i16, 8);
}

pub fn unknown5(self: @This()) i16 {
    return self.row.at(i16, 10);
}

pub fn unknown6(self: @This()) i16 {
    return self.row.at(i16, 12);
}

pub fn unknown7(self: @This()) i16 {
    return self.row.at(i16, 14);
}

pub fn unknown8(self: @This()) i16 {
    return self.row.at(i16, 16);
}

pub fn unknown9(self: @This()) i16 {
    return self.row.at(i16, 18);
}

pub fn unknown10(self: @This()) i16 {
    return self.row.at(i16, 20);
}

pub fn unknown11(self: @This()) i16 {
    return self.row.at(i16, 22);
}

pub fn unknown12(self: @This()) u8 {
    return self.row.at(u8, 24);
}

pub fn unknown13(self: @This()) u8 {
    return self.row.at(u8, 25);
}

pub fn unknown14(self: @This()) u8 {
    return self.row.at(u8, 26);
}

pub fn unknown15(self: @This()) u8 {
    return self.row.at(u8, 27);
}

pub fn unknown16(self: @This()) u8 {
    return self.row.at(u8, 28);
}
