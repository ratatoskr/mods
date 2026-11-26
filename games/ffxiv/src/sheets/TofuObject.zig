//! `TofuObject`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TofuObject = @This();

pub const sheet_name = "TofuObject";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc04a3f52;
pub const Sheet = excel.Typed(TofuObject);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn altIcon(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn unknown3(self: @This()) i32 {
    return self.row.at(i32, 12);
}

pub fn unknown4(self: @This()) i32 {
    return self.row.at(i32, 16);
}

pub fn unknown5(self: @This()) i32 {
    return self.row.at(i32, 20);
}

pub fn unknown6(self: @This()) i32 {
    return self.row.at(i32, 24);
}

pub fn unknown7(self: @This()) i32 {
    return self.row.at(i32, 28);
}

pub fn unknown8(self: @This()) i32 {
    return self.row.at(i32, 32);
}

pub fn unknown9(self: @This()) u16 {
    return self.row.at(u16, 36);
}

pub fn unknown16(self: @This()) u16 {
    return self.row.at(u16, 38);
}

pub fn unknown17(self: @This()) u16 {
    return self.row.at(u16, 40);
}

pub fn unknown18(self: @This()) i16 {
    return self.row.at(i16, 42);
}

pub fn unknown19(self: @This()) i16 {
    return self.row.at(i16, 44);
}

pub fn unknown20(self: @This()) i16 {
    return self.row.at(i16, 46);
}

pub fn unknown21(self: @This()) i16 {
    return self.row.at(i16, 48);
}

pub fn unknown10(self: @This()) i16 {
    return self.row.at(i16, 50);
}

/// Links to `TofuObjectCategory`.
pub fn category(self: @This()) excel.Link(sheets.TofuObjectCategory) {
    return .of(self.row.at(u8, 52));
}

pub fn unknown12(self: @This()) i8 {
    return self.row.at(i8, 53);
}

pub fn unknown13(self: @This()) bool {
    return self.row.bitAt(54, 0);
}

pub fn unknown14(self: @This()) bool {
    return self.row.bitAt(54, 1);
}

pub fn unknown15(self: @This()) bool {
    return self.row.bitAt(54, 2);
}
