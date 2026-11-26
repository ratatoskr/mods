//! `CharaCardDesignType`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CharaCardDesignType = @This();

pub const sheet_name = "CharaCardDesignType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xcd656c92;
pub const Sheet = excel.Typed(CharaCardDesignType);

row: excel.Row,

pub fn unknown0(self: @This()) bool {
    return self.row.at(u8, 0) != 0;
}

pub fn unknown1(self: @This()) bool {
    return self.row.at(u8, 1) != 0;
}

pub fn unknown2(self: @This()) bool {
    return self.row.at(u8, 2) != 0;
}

pub fn unknown3(self: @This()) bool {
    return self.row.bitAt(3, 0);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(3, 1);
}

pub fn unknown5(self: @This()) bool {
    return self.row.bitAt(3, 2);
}

pub fn unknown6(self: @This()) bool {
    return self.row.bitAt(3, 3);
}

pub fn unknown7(self: @This()) bool {
    return self.row.bitAt(3, 4);
}

pub fn unknown8(self: @This()) bool {
    return self.row.bitAt(3, 5);
}

pub fn unknown9(self: @This()) bool {
    return self.row.bitAt(3, 6);
}
