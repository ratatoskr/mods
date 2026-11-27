//! `WKSFortunePatternUIPlace`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSFortunePatternUIPlace = @This();

pub const sheet_name = "WKSFortunePatternUIPlace";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x302198c8;
pub const Sheet = excel.Typed(WKSFortunePatternUIPlace);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Unknown20", "Unknown1", "Unknown21", "Unknown2", "Unknown22", "Unknown3", "Unknown23", "Unknown4", "Unknown24", "Unknown5", "Unknown25", "Unknown6", "Unknown26", "Unknown7", "Unknown27", "Unknown8", "Unknown28", "Unknown9", "Unknown29", "Unknown10", "Unknown30", "Unknown11", "Unknown31", "Unknown12", "Unknown32", "Unknown13", "Unknown33", "Unknown14", "Unknown34", "Unknown15", "Unknown35", "Unknown16", "Unknown36", "Unknown17", "Unknown37", "Unknown18", "Unknown38", "Unknown19", "Unknown39" };

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unknown2(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn unknown3(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn unknown4(self: @This()) u32 {
    return self.row.at(u32, 16);
}

pub fn unknown5(self: @This()) u32 {
    return self.row.at(u32, 20);
}

pub fn unknown6(self: @This()) u32 {
    return self.row.at(u32, 24);
}

pub fn unknown7(self: @This()) u32 {
    return self.row.at(u32, 28);
}

pub fn unknown8(self: @This()) u32 {
    return self.row.at(u32, 32);
}

pub fn unknown9(self: @This()) u32 {
    return self.row.at(u32, 36);
}

pub fn unknown10(self: @This()) u32 {
    return self.row.at(u32, 40);
}

pub fn unknown11(self: @This()) u32 {
    return self.row.at(u32, 44);
}

pub fn unknown12(self: @This()) u32 {
    return self.row.at(u32, 48);
}

pub fn unknown13(self: @This()) u32 {
    return self.row.at(u32, 52);
}

pub fn unknown14(self: @This()) u32 {
    return self.row.at(u32, 56);
}

pub fn unknown15(self: @This()) u32 {
    return self.row.at(u32, 60);
}

pub fn unknown16(self: @This()) u32 {
    return self.row.at(u32, 64);
}

pub fn unknown17(self: @This()) u32 {
    return self.row.at(u32, 68);
}

pub fn unknown18(self: @This()) u32 {
    return self.row.at(u32, 72);
}

pub fn unknown19(self: @This()) u32 {
    return self.row.at(u32, 76);
}

pub fn unknown20(self: @This()) u32 {
    return self.row.at(u32, 80);
}

pub fn unknown21(self: @This()) u32 {
    return self.row.at(u32, 84);
}

pub fn unknown22(self: @This()) u32 {
    return self.row.at(u32, 88);
}

pub fn unknown23(self: @This()) u32 {
    return self.row.at(u32, 92);
}

pub fn unknown24(self: @This()) u32 {
    return self.row.at(u32, 96);
}

pub fn unknown25(self: @This()) u32 {
    return self.row.at(u32, 100);
}

pub fn unknown26(self: @This()) u32 {
    return self.row.at(u32, 104);
}

pub fn unknown27(self: @This()) u32 {
    return self.row.at(u32, 108);
}

pub fn unknown28(self: @This()) u32 {
    return self.row.at(u32, 112);
}

pub fn unknown29(self: @This()) u32 {
    return self.row.at(u32, 116);
}

pub fn unknown30(self: @This()) u32 {
    return self.row.at(u32, 120);
}

pub fn unknown31(self: @This()) u32 {
    return self.row.at(u32, 124);
}

pub fn unknown32(self: @This()) u32 {
    return self.row.at(u32, 128);
}

pub fn unknown33(self: @This()) u32 {
    return self.row.at(u32, 132);
}

pub fn unknown34(self: @This()) u32 {
    return self.row.at(u32, 136);
}

pub fn unknown35(self: @This()) u32 {
    return self.row.at(u32, 140);
}

pub fn unknown36(self: @This()) u32 {
    return self.row.at(u32, 144);
}

pub fn unknown37(self: @This()) u32 {
    return self.row.at(u32, 148);
}

pub fn unknown38(self: @This()) u32 {
    return self.row.at(u32, 152);
}

pub fn unknown39(self: @This()) u32 {
    return self.row.at(u32, 156);
}
