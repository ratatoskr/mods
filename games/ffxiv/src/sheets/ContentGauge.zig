//! `ContentGauge`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ContentGauge = @This();

pub const sheet_name = "ContentGauge";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x55e3560d;
pub const Sheet = excel.Typed(ContentGauge);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn textString(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown0(self: @This()) i16 {
    return self.row.at(i16, 8);
}

pub fn unknown1(self: @This()) i16 {
    return self.row.at(i16, 10);
}

pub fn unknown2(self: @This()) i16 {
    return self.row.at(i16, 12);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 14);
}

/// Links to `ContentGaugeColor`.
pub fn color(self: @This()) excel.Link(sheets.ContentGaugeColor) {
    return .of(self.row.at(u8, 15));
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 16);
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 17);
}

pub fn unknown6(self: @This()) i8 {
    return self.row.at(i8, 18);
}

pub fn unknown7(self: @This()) i8 {
    return self.row.at(i8, 19);
}

pub fn unknown8(self: @This()) bool {
    return self.row.bitAt(20, 0);
}
