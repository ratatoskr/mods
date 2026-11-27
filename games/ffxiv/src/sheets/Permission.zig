//! `Permission`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Permission = @This();

pub const sheet_name = "Permission";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xa2e64547;
pub const Sheet = excel.Typed(Permission);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Unknown1", "Unknown2", "Unknown3", "Unknown4", "Unknown5", "Unknown6", "Unknown7", "Unknown8", "Unknown9", "Unknown10", "Unknown11", "Unknown12", "Unknown13", "Unknown14", "Unknown15", "Unknown16", "Unknown17", "Unknown18", "Unknown19", "Unknown20", "Unknown21", "Unknown22", "Unknown23", "Unknown24", "Unknown25", "Unknown26", "Unknown27", "Unknown28", "Unknown29", "Unknown30", "Unknown31", "Unknown32", "Unknown33", "Unknown34", "Unknown35", "Unknown36", "Unknown37", "Unknown38", "Unknown39", "Unknown40", "Unknown41", "Unknown42", "Unknown43", "Unknown44", "Unknown45", "Unknown46", "Unknown47", "Unknown48", "Unknown49", "Unknown50", "Unknown51", "Unknown52", "Unknown53", "Unknown54", "Unknown55", "Unknown56", "Unknown57", "Unknown58", "Unknown59", "Unknown60", "Unknown61", "Unknown62", "Unknown63", "Unknown64", "Unknown65", "Unknown66", "Unknown67", "Unknown68", "Unknown69", "Unknown70", "Unknown71", "Unknown72", "Unknown73", "Unknown74", "Unknown75", "Unknown76", "Unknown77", "Unknown78", "Unknown79", "Unknown80", "Unknown81", "Unknown82", "Unknown83", "Unknown84", "Unknown85", "Unknown86", "Unknown87", "Unknown88", "Unknown89", "Unknown90", "Unknown91", "Unknown92", "Unknown93", "Unknown94", "Unknown95", "Unknown96", "Unknown97", "Unknown98", "Unknown99", "Unknown100", "Unknown101", "Unknown102", "Unknown104", "Unknown105", "Unknown106", "Unknown107", "Unknown108", "Unknown109", "Unknown110", "Unknown111", "Unknown103" };

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
    return self.row.at(u8, 3) != 0;
}

pub fn unknown4(self: @This()) bool {
    return self.row.at(u8, 4) != 0;
}

pub fn unknown5(self: @This()) bool {
    return self.row.at(u8, 5) != 0;
}

pub fn unknown6(self: @This()) bool {
    return self.row.at(u8, 6) != 0;
}

pub fn unknown7(self: @This()) bool {
    return self.row.at(u8, 7) != 0;
}

pub fn unknown8(self: @This()) bool {
    return self.row.at(u8, 8) != 0;
}

pub fn unknown9(self: @This()) bool {
    return self.row.at(u8, 9) != 0;
}

pub fn unknown10(self: @This()) bool {
    return self.row.at(u8, 10) != 0;
}

pub fn unknown11(self: @This()) bool {
    return self.row.at(u8, 11) != 0;
}

pub fn unknown12(self: @This()) bool {
    return self.row.at(u8, 12) != 0;
}

pub fn unknown13(self: @This()) bool {
    return self.row.at(u8, 13) != 0;
}

pub fn unknown14(self: @This()) bool {
    return self.row.at(u8, 14) != 0;
}

pub fn unknown15(self: @This()) bool {
    return self.row.at(u8, 15) != 0;
}

pub fn unknown16(self: @This()) bool {
    return self.row.at(u8, 16) != 0;
}

pub fn unknown17(self: @This()) bool {
    return self.row.at(u8, 17) != 0;
}

pub fn unknown18(self: @This()) bool {
    return self.row.at(u8, 18) != 0;
}

pub fn unknown19(self: @This()) bool {
    return self.row.at(u8, 19) != 0;
}

pub fn unknown20(self: @This()) bool {
    return self.row.at(u8, 20) != 0;
}

pub fn unknown21(self: @This()) bool {
    return self.row.at(u8, 21) != 0;
}

pub fn unknown22(self: @This()) bool {
    return self.row.at(u8, 22) != 0;
}

pub fn unknown23(self: @This()) bool {
    return self.row.at(u8, 23) != 0;
}

pub fn unknown24(self: @This()) bool {
    return self.row.at(u8, 24) != 0;
}

pub fn unknown25(self: @This()) bool {
    return self.row.at(u8, 25) != 0;
}

pub fn unknown26(self: @This()) bool {
    return self.row.at(u8, 26) != 0;
}

pub fn unknown27(self: @This()) bool {
    return self.row.at(u8, 27) != 0;
}

pub fn unknown28(self: @This()) bool {
    return self.row.at(u8, 28) != 0;
}

pub fn unknown29(self: @This()) bool {
    return self.row.at(u8, 29) != 0;
}

pub fn unknown30(self: @This()) bool {
    return self.row.at(u8, 30) != 0;
}

pub fn unknown31(self: @This()) bool {
    return self.row.at(u8, 31) != 0;
}

pub fn unknown32(self: @This()) bool {
    return self.row.at(u8, 32) != 0;
}

pub fn unknown33(self: @This()) bool {
    return self.row.at(u8, 33) != 0;
}

pub fn unknown34(self: @This()) bool {
    return self.row.at(u8, 34) != 0;
}

pub fn unknown35(self: @This()) bool {
    return self.row.at(u8, 35) != 0;
}

pub fn unknown36(self: @This()) bool {
    return self.row.at(u8, 36) != 0;
}

pub fn unknown37(self: @This()) bool {
    return self.row.at(u8, 37) != 0;
}

pub fn unknown38(self: @This()) bool {
    return self.row.at(u8, 38) != 0;
}

pub fn unknown39(self: @This()) bool {
    return self.row.at(u8, 39) != 0;
}

pub fn unknown40(self: @This()) bool {
    return self.row.at(u8, 40) != 0;
}

pub fn unknown41(self: @This()) bool {
    return self.row.at(u8, 41) != 0;
}

pub fn unknown42(self: @This()) bool {
    return self.row.at(u8, 42) != 0;
}

pub fn unknown43(self: @This()) bool {
    return self.row.at(u8, 43) != 0;
}

pub fn unknown44(self: @This()) bool {
    return self.row.at(u8, 44) != 0;
}

pub fn unknown45(self: @This()) bool {
    return self.row.at(u8, 45) != 0;
}

pub fn unknown46(self: @This()) bool {
    return self.row.at(u8, 46) != 0;
}

pub fn unknown47(self: @This()) bool {
    return self.row.at(u8, 47) != 0;
}

pub fn unknown48(self: @This()) bool {
    return self.row.at(u8, 48) != 0;
}

pub fn unknown49(self: @This()) bool {
    return self.row.at(u8, 49) != 0;
}

pub fn unknown50(self: @This()) bool {
    return self.row.at(u8, 50) != 0;
}

pub fn unknown51(self: @This()) bool {
    return self.row.at(u8, 51) != 0;
}

pub fn unknown52(self: @This()) bool {
    return self.row.at(u8, 52) != 0;
}

pub fn unknown53(self: @This()) bool {
    return self.row.at(u8, 53) != 0;
}

pub fn unknown54(self: @This()) bool {
    return self.row.at(u8, 54) != 0;
}

pub fn unknown55(self: @This()) bool {
    return self.row.at(u8, 55) != 0;
}

pub fn unknown56(self: @This()) bool {
    return self.row.at(u8, 56) != 0;
}

pub fn unknown57(self: @This()) bool {
    return self.row.at(u8, 57) != 0;
}

pub fn unknown58(self: @This()) bool {
    return self.row.at(u8, 58) != 0;
}

pub fn unknown59(self: @This()) bool {
    return self.row.at(u8, 59) != 0;
}

pub fn unknown60(self: @This()) bool {
    return self.row.at(u8, 60) != 0;
}

pub fn unknown61(self: @This()) bool {
    return self.row.at(u8, 61) != 0;
}

pub fn unknown62(self: @This()) bool {
    return self.row.at(u8, 62) != 0;
}

pub fn unknown63(self: @This()) bool {
    return self.row.at(u8, 63) != 0;
}

pub fn unknown64(self: @This()) bool {
    return self.row.at(u8, 64) != 0;
}

pub fn unknown65(self: @This()) bool {
    return self.row.at(u8, 65) != 0;
}

pub fn unknown66(self: @This()) bool {
    return self.row.at(u8, 66) != 0;
}

pub fn unknown67(self: @This()) bool {
    return self.row.at(u8, 67) != 0;
}

pub fn unknown68(self: @This()) bool {
    return self.row.at(u8, 68) != 0;
}

pub fn unknown69(self: @This()) bool {
    return self.row.at(u8, 69) != 0;
}

pub fn unknown70(self: @This()) bool {
    return self.row.at(u8, 70) != 0;
}

pub fn unknown71(self: @This()) bool {
    return self.row.at(u8, 71) != 0;
}

pub fn unknown72(self: @This()) bool {
    return self.row.at(u8, 72) != 0;
}

pub fn unknown73(self: @This()) bool {
    return self.row.at(u8, 73) != 0;
}

pub fn unknown74(self: @This()) bool {
    return self.row.at(u8, 74) != 0;
}

pub fn unknown75(self: @This()) bool {
    return self.row.at(u8, 75) != 0;
}

pub fn unknown76(self: @This()) bool {
    return self.row.at(u8, 76) != 0;
}

pub fn unknown77(self: @This()) bool {
    return self.row.at(u8, 77) != 0;
}

pub fn unknown78(self: @This()) bool {
    return self.row.at(u8, 78) != 0;
}

pub fn unknown79(self: @This()) bool {
    return self.row.at(u8, 79) != 0;
}

pub fn unknown80(self: @This()) bool {
    return self.row.at(u8, 80) != 0;
}

pub fn unknown81(self: @This()) bool {
    return self.row.at(u8, 81) != 0;
}

pub fn unknown82(self: @This()) bool {
    return self.row.at(u8, 82) != 0;
}

pub fn unknown83(self: @This()) bool {
    return self.row.at(u8, 83) != 0;
}

pub fn unknown84(self: @This()) bool {
    return self.row.at(u8, 84) != 0;
}

pub fn unknown85(self: @This()) bool {
    return self.row.at(u8, 85) != 0;
}

pub fn unknown86(self: @This()) bool {
    return self.row.at(u8, 86) != 0;
}

pub fn unknown87(self: @This()) bool {
    return self.row.at(u8, 87) != 0;
}

pub fn unknown88(self: @This()) bool {
    return self.row.at(u8, 88) != 0;
}

pub fn unknown89(self: @This()) bool {
    return self.row.at(u8, 89) != 0;
}

pub fn unknown90(self: @This()) bool {
    return self.row.at(u8, 90) != 0;
}

pub fn unknown91(self: @This()) bool {
    return self.row.at(u8, 91) != 0;
}

pub fn unknown92(self: @This()) bool {
    return self.row.at(u8, 92) != 0;
}

pub fn unknown93(self: @This()) bool {
    return self.row.at(u8, 93) != 0;
}

pub fn unknown94(self: @This()) bool {
    return self.row.at(u8, 94) != 0;
}

pub fn unknown95(self: @This()) bool {
    return self.row.at(u8, 95) != 0;
}

pub fn unknown96(self: @This()) bool {
    return self.row.at(u8, 96) != 0;
}

pub fn unknown97(self: @This()) bool {
    return self.row.at(u8, 97) != 0;
}

pub fn unknown98(self: @This()) bool {
    return self.row.at(u8, 98) != 0;
}

pub fn unknown99(self: @This()) bool {
    return self.row.at(u8, 99) != 0;
}

pub fn unknown100(self: @This()) bool {
    return self.row.at(u8, 100) != 0;
}

pub fn unknown101(self: @This()) bool {
    return self.row.at(u8, 101) != 0;
}

pub fn unknown102(self: @This()) bool {
    return self.row.at(u8, 102) != 0;
}

pub fn unknown104(self: @This()) bool {
    return self.row.at(u8, 103) != 0;
}

pub fn unknown105(self: @This()) bool {
    return self.row.at(u8, 104) != 0;
}

pub fn unknown106(self: @This()) bool {
    return self.row.at(u8, 105) != 0;
}

pub fn unknown107(self: @This()) bool {
    return self.row.at(u8, 106) != 0;
}

pub fn unknown108(self: @This()) bool {
    return self.row.at(u8, 107) != 0;
}

pub fn unknown109(self: @This()) bool {
    return self.row.at(u8, 108) != 0;
}

pub fn unknown110(self: @This()) bool {
    return self.row.at(u8, 109) != 0;
}

pub fn unknown111(self: @This()) bool {
    return self.row.at(u8, 110) != 0;
}

pub fn unknown103(self: @This()) bool {
    return self.row.at(u8, 111) != 0;
}
