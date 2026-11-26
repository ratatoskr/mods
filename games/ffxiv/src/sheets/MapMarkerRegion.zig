//! `MapMarkerRegion`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `X`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MapMarkerRegion = @This();

pub const sheet_name = "MapMarkerRegion";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe2747195;
pub const Sheet = excel.Typed(MapMarkerRegion);

row: excel.Row,

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 2);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn unknown3(self: @This()) u16 {
    return self.row.at(u16, 6);
}

pub fn x(self: @This()) i16 {
    return self.row.at(i16, 8);
}

pub fn unknown4(self: @This()) i16 {
    return self.row.at(i16, 10);
}

pub fn unknown5(self: @This()) i16 {
    return self.row.at(i16, 12);
}

pub fn unknown6(self: @This()) i16 {
    return self.row.at(i16, 14);
}

pub fn unknown7(self: @This()) i16 {
    return self.row.at(i16, 16);
}

pub fn unknown8(self: @This()) i16 {
    return self.row.at(i16, 18);
}

pub fn unknown9(self: @This()) u8 {
    return self.row.at(u8, 20);
}

pub fn unknown10(self: @This()) bool {
    return self.row.bitAt(21, 0);
}
