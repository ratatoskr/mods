//! `HousingPileLimit`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HousingPileLimit = @This();

pub const sheet_name = "HousingPileLimit";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x418885b6;
pub const Sheet = excel.Typed(HousingPileLimit);

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

pub fn unknown3(self: @This()) bool {
    return self.row.at(u8, 6) != 0;
}

pub fn unknown4(self: @This()) bool {
    return self.row.at(u8, 7) != 0;
}

pub fn unknown5(self: @This()) bool {
    return self.row.at(u8, 8) != 0;
}

pub fn unknown6(self: @This()) bool {
    return self.row.at(u8, 9) != 0;
}

pub fn unknown7(self: @This()) bool {
    return self.row.at(u8, 10) != 0;
}
