//! `ContentCloseCycle`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ContentCloseCycle = @This();

pub const sheet_name = "ContentCloseCycle";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd3032cdb;
pub const Sheet = excel.Typed(ContentCloseCycle);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unixtime", "TimeSeconds", "Unknown0", "Unknown1", "Unknown2", "Unknown3", "Unknown4", "Unknown5", "Unknown6", "Unknown7", "Unknown8", "Unknown9", "Unknown10" };

pub fn unixtime(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn timeSeconds(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn unknown1(self: @This()) bool {
    return self.row.at(u8, 12) != 0;
}

pub fn unknown2(self: @This()) bool {
    return self.row.at(u8, 13) != 0;
}

pub fn unknown3(self: @This()) bool {
    return self.row.at(u8, 14) != 0;
}

pub fn unknown4(self: @This()) bool {
    return self.row.at(u8, 15) != 0;
}

pub fn unknown5(self: @This()) bool {
    return self.row.at(u8, 16) != 0;
}

pub fn unknown6(self: @This()) bool {
    return self.row.at(u8, 17) != 0;
}

pub fn unknown7(self: @This()) bool {
    return self.row.at(u8, 18) != 0;
}

pub fn unknown8(self: @This()) bool {
    return self.row.at(u8, 19) != 0;
}

pub fn unknown9(self: @This()) bool {
    return self.row.at(u8, 20) != 0;
}

pub fn unknown10(self: @This()) bool {
    return self.row.at(u8, 21) != 0;
}
