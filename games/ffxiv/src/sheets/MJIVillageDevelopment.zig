//! `MJIVillageDevelopment`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJIVillageDevelopment = @This();

pub const sheet_name = "MJIVillageDevelopment";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x038243ca;
pub const Sheet = excel.Typed(MJIVillageDevelopment);

row: excel.Row,

/// Links to `ENpcResident`.
pub fn enpc(self: @This()) excel.Link(sheets.ENpcResident) {
    return .of(self.row.at(u32, 0));
}

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn unknown2(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn unknown3(self: @This()) u32 {
    return self.row.at(u32, 16);
}

pub fn unknown4(self: @This()) u32 {
    return self.row.at(u32, 20);
}

/// Links to `Behavior`.
pub fn behavior0(self: @This()) excel.Link(sheets.Behavior) {
    return .of(self.row.at(u16, 24));
}

/// Links to `Behavior`.
pub fn behavior1(self: @This()) excel.Link(sheets.Behavior) {
    return .of(self.row.at(u16, 26));
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 28);
}

pub fn unknown6(self: @This()) u8 {
    return self.row.at(u8, 29);
}

pub fn unknown7(self: @This()) u8 {
    return self.row.at(u8, 30);
}

pub fn unknown8(self: @This()) u8 {
    return self.row.at(u8, 31);
}

pub fn unknown9(self: @This()) u8 {
    return self.row.at(u8, 32);
}

pub fn unknown10(self: @This()) u8 {
    return self.row.at(u8, 33);
}

pub fn unknown11(self: @This()) u8 {
    return self.row.at(u8, 34);
}
