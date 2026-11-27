//! `SystemGraphicPreset`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SystemGraphicPreset = @This();

pub const sheet_name = "SystemGraphicPreset";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xa904455e;
pub const Sheet = excel.Typed(SystemGraphicPreset);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Unknown1", "Unknown2", "Unknown3", "Unknown4", "Unknown5", "Unknown6", "Unknown7", "Unknown8", "Unknown9", "Unknown10", "Unknown11", "Unknown12", "Unknown13", "Unknown14", "Unknown15", "Unknown16", "Unknown17", "Unknown18", "Unknown19", "Unknown20", "Unknown21", "Unknown22", "Unknown23", "Unknown24", "Unknown25", "Unknown26", "Unknown27", "Unknown28", "Unknown29", "Unknown30", "Unknown31", "Unknown32", "Unknown_70_1", "Unknown_70_2", "Unknown_70_3", "Unknown_70_4", "Unknown_70_5", "Unknown_70_6", "Unknown_70_7" };

pub fn unknown0(self: @This()) i8 {
    return self.row.at(i8, 0);
}

pub fn unknown1(self: @This()) i8 {
    return self.row.at(i8, 1);
}

pub fn unknown2(self: @This()) i8 {
    return self.row.at(i8, 2);
}

pub fn unknown3(self: @This()) i8 {
    return self.row.at(i8, 3);
}

pub fn unknown4(self: @This()) i8 {
    return self.row.at(i8, 4);
}

pub fn unknown5(self: @This()) i8 {
    return self.row.at(i8, 5);
}

pub fn unknown6(self: @This()) i8 {
    return self.row.at(i8, 6);
}

pub fn unknown7(self: @This()) i8 {
    return self.row.at(i8, 7);
}

pub fn unknown8(self: @This()) i8 {
    return self.row.at(i8, 8);
}

pub fn unknown9(self: @This()) i8 {
    return self.row.at(i8, 9);
}

pub fn unknown10(self: @This()) i8 {
    return self.row.at(i8, 10);
}

pub fn unknown11(self: @This()) i8 {
    return self.row.at(i8, 11);
}

pub fn unknown12(self: @This()) i8 {
    return self.row.at(i8, 12);
}

pub fn unknown13(self: @This()) i8 {
    return self.row.at(i8, 13);
}

pub fn unknown14(self: @This()) i8 {
    return self.row.at(i8, 14);
}

pub fn unknown15(self: @This()) i8 {
    return self.row.at(i8, 15);
}

pub fn unknown16(self: @This()) i8 {
    return self.row.at(i8, 16);
}

pub fn unknown17(self: @This()) i8 {
    return self.row.at(i8, 17);
}

pub fn unknown18(self: @This()) i8 {
    return self.row.at(i8, 18);
}

pub fn unknown19(self: @This()) i8 {
    return self.row.at(i8, 19);
}

pub fn unknown20(self: @This()) i8 {
    return self.row.at(i8, 20);
}

pub fn unknown21(self: @This()) i8 {
    return self.row.at(i8, 21);
}

pub fn unknown22(self: @This()) i8 {
    return self.row.at(i8, 22);
}

pub fn unknown23(self: @This()) i8 {
    return self.row.at(i8, 23);
}

pub fn unknown24(self: @This()) i8 {
    return self.row.at(i8, 24);
}

pub fn unknown25(self: @This()) i8 {
    return self.row.at(i8, 25);
}

pub fn unknown26(self: @This()) i8 {
    return self.row.at(i8, 26);
}

pub fn unknown27(self: @This()) i8 {
    return self.row.at(i8, 27);
}

pub fn unknown28(self: @This()) i8 {
    return self.row.at(i8, 28);
}

pub fn unknown29(self: @This()) i8 {
    return self.row.at(i8, 29);
}

pub fn unknown30(self: @This()) i8 {
    return self.row.at(i8, 30);
}

pub fn unknown31(self: @This()) i8 {
    return self.row.at(i8, 31);
}

pub fn unknown32(self: @This()) i8 {
    return self.row.at(i8, 32);
}

pub fn unknown_70_1(self: @This()) i8 {
    return self.row.at(i8, 33);
}

pub fn unknown_70_2(self: @This()) i8 {
    return self.row.at(i8, 34);
}

pub fn unknown_70_3(self: @This()) i8 {
    return self.row.at(i8, 35);
}

pub fn unknown_70_4(self: @This()) i8 {
    return self.row.at(i8, 36);
}

pub fn unknown_70_5(self: @This()) i8 {
    return self.row.at(i8, 37);
}

pub fn unknown_70_6(self: @This()) i8 {
    return self.row.at(i8, 38);
}

pub fn unknown_70_7(self: @This()) i8 {
    return self.row.at(i8, 39);
}
