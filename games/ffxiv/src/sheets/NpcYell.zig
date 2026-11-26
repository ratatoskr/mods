//! `NpcYell`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Text`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const NpcYell = @This();

pub const sheet_name = "NpcYell";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x10700cb2;
pub const Sheet = excel.Typed(NpcYell);

row: excel.Row,

pub fn text(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown6(self: @This()) f32 {
    return self.row.at(f32, 4);
}

pub fn balloonTime(self: @This()) f32 {
    return self.row.at(f32, 8);
}

/// Links to `ENpcResident` or `BNpcName`, whichever has the row.
pub fn name(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn unknown7(self: @This()) u32 {
    return self.row.at(u32, 16);
}

pub fn unknown8(self: @This()) u16 {
    return self.row.at(u16, 20);
}

pub fn outputType(self: @This()) u8 {
    return self.row.at(u8, 22);
}

pub fn unknown_70(self: @This()) u8 {
    return self.row.at(u8, 23);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 24);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 25);
}

pub fn unknown3(self: @This()) bool {
    return self.row.bitAt(26, 0);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(26, 1);
}

pub fn unknown5(self: @This()) bool {
    return self.row.bitAt(26, 2);
}

pub fn isBalloonSlow(self: @This()) bool {
    return self.row.bitAt(26, 3);
}

pub fn battleTalkTime(self: @This()) bool {
    return self.row.bitAt(26, 4);
}
