//! `DawnContent`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Content`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DawnContent = @This();

pub const sheet_name = "DawnContent";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x7cba2808;
pub const Sheet = excel.Typed(DawnContent);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Content", "Unknown12", "Unknown15", "Unknown16", "Unknown13", "Unknown14", "ExpBelowExMaxLvl", "ExpAboveExMaxLvl", "Unknown0", "Unknown11", "Unknown1", "Unknown2", "Unknown3", "Unknown4", "Unknown5", "Unknown6", "Unknown7", "Unknown8", "Unknown9", "Unknown10" };

/// Links to `ContentFinderCondition`.
pub fn content(self: @This()) excel.Link(sheets.ContentFinderCondition) {
    return .of(self.row.at(u32, 0));
}

pub fn expBelowExMaxLvl(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn expAboveExMaxLvl(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 16);
}

pub fn unknown2(self: @This()) u32 {
    return self.row.at(u32, 20);
}

pub fn unknown3(self: @This()) u32 {
    return self.row.at(u32, 24);
}

pub fn unknown4(self: @This()) u32 {
    return self.row.at(u32, 28);
}

pub fn unknown5(self: @This()) u32 {
    return self.row.at(u32, 32);
}

pub fn unknown6(self: @This()) u32 {
    return self.row.at(u32, 36);
}

pub fn unknown7(self: @This()) u32 {
    return self.row.at(u32, 40);
}

pub fn unknown8(self: @This()) u32 {
    return self.row.at(u32, 44);
}

pub fn unknown9(self: @This()) u32 {
    return self.row.at(u32, 48);
}

pub fn unknown10(self: @This()) u32 {
    return self.row.at(u32, 52);
}

pub fn unknown15(self: @This()) u16 {
    return self.row.at(u16, 56);
}

pub fn unknown11(self: @This()) u8 {
    return self.row.at(u8, 58);
}

pub fn unknown12(self: @This()) bool {
    return self.row.bitAt(59, 0);
}

pub fn unknown16(self: @This()) bool {
    return self.row.bitAt(59, 1);
}

pub fn unknown13(self: @This()) bool {
    return self.row.bitAt(59, 2);
}

pub fn unknown14(self: @This()) bool {
    return self.row.bitAt(59, 3);
}
