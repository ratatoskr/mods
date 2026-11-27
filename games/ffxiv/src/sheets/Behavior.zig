//! `Behavior`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Behavior = @This();

pub const sheet_name = "Behavior";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x858a7450;
pub const Sheet = excel.Typed(Behavior);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown6", "Unknown7", "Condition0Target", "Condition0Type", "Unknown1", "Unknown5", "Unknown2", "Unknown3", "Balloon", "Condition1Target", "Condition1Type", "ContentArgument0", "ContentArgument1", "Unknown8", "Unknown9", "Unknown0", "Unknown4" };

pub fn contentArgument0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unknown1(self: @This()) i32 {
    return self.row.at(i32, 8);
}

pub fn unknown2(self: @This()) i32 {
    return self.row.at(i32, 12);
}

pub fn unknown3(self: @This()) u16 {
    return self.row.at(u16, 16);
}

/// Links to `Balloon`.
pub fn balloon(self: @This()) excel.Link(sheets.Balloon) {
    return .of(self.row.at(u16, 18));
}

pub fn unknown4(self: @This()) u16 {
    return self.row.at(u16, 20);
}

pub fn unknown5(self: @This()) i16 {
    return self.row.at(i16, 22);
}

pub fn unknown6(self: @This()) u8 {
    return self.row.at(u8, 24);
}

pub fn unknown7(self: @This()) u8 {
    return self.row.at(u8, 25);
}

pub fn condition0Target(self: @This()) u8 {
    return self.row.at(u8, 26);
}

pub fn condition0Type(self: @This()) u8 {
    return self.row.at(u8, 27);
}

pub fn condition1Target(self: @This()) u8 {
    return self.row.at(u8, 28);
}

pub fn condition1Type(self: @This()) u8 {
    return self.row.at(u8, 29);
}

pub fn contentArgument1(self: @This()) u8 {
    return self.row.at(u8, 30);
}

pub fn unknown8(self: @This()) u8 {
    return self.row.at(u8, 31);
}

pub fn unknown9(self: @This()) u8 {
    return self.row.at(u8, 32);
}
