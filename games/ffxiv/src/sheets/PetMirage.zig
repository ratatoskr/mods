//! `PetMirage`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PetMirage = @This();

pub const sheet_name = "PetMirage";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc3af1cc0;
pub const Sheet = excel.Typed(PetMirage);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Scale", "ModelChara", "Name", "Unknown0", "Unknown4", "Unknown8", "Unknown12", "Unknown16", "Unknown20", "Unknown24", "Unknown28", "Unknown32", "Unknown36", "Unknown40", "Unknown44", "Unknown48", "Unknown52", "Unknown56", "Unknown3", "Unknown7", "Unknown11", "Unknown15", "Unknown19", "Unknown23", "Unknown27", "Unknown31", "Unknown35", "Unknown39", "Unknown43", "Unknown47", "Unknown51", "Unknown55", "Unknown59", "Unknown1", "Unknown5", "Unknown9", "Unknown13", "Unknown17", "Unknown21", "Unknown25", "Unknown29", "Unknown33", "Unknown37", "Unknown41", "Unknown45", "Unknown49", "Unknown53", "Unknown57", "Unknown2", "Unknown6", "Unknown10", "Unknown14", "Unknown18", "Unknown22", "Unknown26", "Unknown30", "Unknown34", "Unknown38", "Unknown42", "Unknown46", "Unknown50", "Unknown54", "Unknown58" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 6);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 10);
}

pub fn unknown4(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn unknown5(self: @This()) u16 {
    return self.row.at(u16, 14);
}

pub fn unknown6(self: @This()) u16 {
    return self.row.at(u16, 16);
}

pub fn unknown7(self: @This()) u8 {
    return self.row.at(u8, 18);
}

pub fn unknown8(self: @This()) u16 {
    return self.row.at(u16, 20);
}

pub fn unknown9(self: @This()) u16 {
    return self.row.at(u16, 22);
}

pub fn unknown10(self: @This()) u16 {
    return self.row.at(u16, 24);
}

pub fn unknown11(self: @This()) u8 {
    return self.row.at(u8, 26);
}

pub fn unknown12(self: @This()) u16 {
    return self.row.at(u16, 28);
}

pub fn unknown13(self: @This()) u16 {
    return self.row.at(u16, 30);
}

pub fn unknown14(self: @This()) u16 {
    return self.row.at(u16, 32);
}

pub fn unknown15(self: @This()) u8 {
    return self.row.at(u8, 34);
}

pub fn unknown16(self: @This()) u16 {
    return self.row.at(u16, 36);
}

pub fn unknown17(self: @This()) u16 {
    return self.row.at(u16, 38);
}

pub fn unknown18(self: @This()) u16 {
    return self.row.at(u16, 40);
}

pub fn unknown19(self: @This()) u8 {
    return self.row.at(u8, 42);
}

pub fn unknown20(self: @This()) u16 {
    return self.row.at(u16, 44);
}

pub fn unknown21(self: @This()) u16 {
    return self.row.at(u16, 46);
}

pub fn unknown22(self: @This()) u16 {
    return self.row.at(u16, 48);
}

pub fn unknown23(self: @This()) u8 {
    return self.row.at(u8, 50);
}

pub fn unknown24(self: @This()) u16 {
    return self.row.at(u16, 52);
}

pub fn unknown25(self: @This()) u16 {
    return self.row.at(u16, 54);
}

pub fn unknown26(self: @This()) u16 {
    return self.row.at(u16, 56);
}

pub fn unknown27(self: @This()) u8 {
    return self.row.at(u8, 58);
}

pub fn unknown28(self: @This()) u16 {
    return self.row.at(u16, 60);
}

pub fn unknown29(self: @This()) u16 {
    return self.row.at(u16, 62);
}

pub fn unknown30(self: @This()) u16 {
    return self.row.at(u16, 64);
}

pub fn unknown31(self: @This()) u8 {
    return self.row.at(u8, 66);
}

pub fn unknown32(self: @This()) u16 {
    return self.row.at(u16, 68);
}

pub fn unknown33(self: @This()) u16 {
    return self.row.at(u16, 70);
}

pub fn unknown34(self: @This()) u16 {
    return self.row.at(u16, 72);
}

pub fn unknown35(self: @This()) u8 {
    return self.row.at(u8, 74);
}

pub fn unknown36(self: @This()) u16 {
    return self.row.at(u16, 76);
}

pub fn unknown37(self: @This()) u16 {
    return self.row.at(u16, 78);
}

pub fn unknown38(self: @This()) u16 {
    return self.row.at(u16, 80);
}

pub fn unknown39(self: @This()) u8 {
    return self.row.at(u8, 82);
}

pub fn unknown40(self: @This()) u16 {
    return self.row.at(u16, 84);
}

pub fn unknown41(self: @This()) u16 {
    return self.row.at(u16, 86);
}

pub fn unknown42(self: @This()) u16 {
    return self.row.at(u16, 88);
}

pub fn unknown43(self: @This()) u8 {
    return self.row.at(u8, 90);
}

pub fn unknown44(self: @This()) u16 {
    return self.row.at(u16, 92);
}

pub fn unknown45(self: @This()) u16 {
    return self.row.at(u16, 94);
}

pub fn unknown46(self: @This()) u16 {
    return self.row.at(u16, 96);
}

pub fn unknown47(self: @This()) u8 {
    return self.row.at(u8, 98);
}

pub fn unknown48(self: @This()) u16 {
    return self.row.at(u16, 100);
}

pub fn unknown49(self: @This()) u16 {
    return self.row.at(u16, 102);
}

pub fn unknown50(self: @This()) u16 {
    return self.row.at(u16, 104);
}

pub fn unknown51(self: @This()) u8 {
    return self.row.at(u8, 106);
}

pub fn unknown52(self: @This()) u16 {
    return self.row.at(u16, 108);
}

pub fn unknown53(self: @This()) u16 {
    return self.row.at(u16, 110);
}

pub fn unknown54(self: @This()) u16 {
    return self.row.at(u16, 112);
}

pub fn unknown55(self: @This()) u8 {
    return self.row.at(u8, 114);
}

pub fn unknown56(self: @This()) u16 {
    return self.row.at(u16, 116);
}

pub fn unknown57(self: @This()) u16 {
    return self.row.at(u16, 118);
}

pub fn unknown58(self: @This()) u16 {
    return self.row.at(u16, 120);
}

pub fn unknown59(self: @This()) u8 {
    return self.row.at(u8, 122);
}

pub fn scale(self: @This()) f32 {
    return self.row.at(f32, 124);
}

/// Links to `ModelChara`.
pub fn modelChara(self: @This()) excel.Link(sheets.ModelChara) {
    return .of(self.row.at(u16, 128));
}
