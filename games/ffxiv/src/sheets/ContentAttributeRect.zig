//! `ContentAttributeRect`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ContentAttributeRect = @This();

pub const sheet_name = "ContentAttributeRect";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x01299c43;
pub const Sheet = excel.Typed(ContentAttributeRect);

row: excel.Row,

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 9);
}

pub fn unknown4(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn unknown5(self: @This()) u32 {
    return self.row.at(u32, 16);
}

pub fn unknown6(self: @This()) u8 {
    return self.row.at(u8, 20);
}

pub fn unknown7(self: @This()) u8 {
    return self.row.at(u8, 21);
}

pub fn unknown8(self: @This()) u32 {
    return self.row.at(u32, 24);
}

pub fn unknown9(self: @This()) u32 {
    return self.row.at(u32, 28);
}

pub fn unknown10(self: @This()) u8 {
    return self.row.at(u8, 32);
}

pub fn unknown11(self: @This()) u8 {
    return self.row.at(u8, 33);
}

pub fn unknown12(self: @This()) u32 {
    return self.row.at(u32, 36);
}

pub fn unknown13(self: @This()) u32 {
    return self.row.at(u32, 40);
}

pub fn unknown14(self: @This()) u8 {
    return self.row.at(u8, 44);
}

pub fn unknown15(self: @This()) u8 {
    return self.row.at(u8, 45);
}

pub fn unknown16(self: @This()) u32 {
    return self.row.at(u32, 48);
}

pub fn unknown17(self: @This()) u32 {
    return self.row.at(u32, 52);
}

pub fn unknown18(self: @This()) u8 {
    return self.row.at(u8, 56);
}

pub fn unknown19(self: @This()) u8 {
    return self.row.at(u8, 57);
}

pub fn unknown20(self: @This()) u32 {
    return self.row.at(u32, 60);
}

pub fn unknown21(self: @This()) u32 {
    return self.row.at(u32, 64);
}

pub fn unknown22(self: @This()) u8 {
    return self.row.at(u8, 68);
}

pub fn unknown23(self: @This()) u8 {
    return self.row.at(u8, 69);
}

pub fn unknown24(self: @This()) u32 {
    return self.row.at(u32, 72);
}

pub fn unknown25(self: @This()) u32 {
    return self.row.at(u32, 76);
}

pub fn unknown26(self: @This()) u8 {
    return self.row.at(u8, 80);
}

pub fn unknown27(self: @This()) u8 {
    return self.row.at(u8, 81);
}

pub fn unknown28(self: @This()) u32 {
    return self.row.at(u32, 84);
}

pub fn unknown29(self: @This()) u32 {
    return self.row.at(u32, 88);
}

pub fn unknown30(self: @This()) u8 {
    return self.row.at(u8, 92);
}

pub fn unknown31(self: @This()) u8 {
    return self.row.at(u8, 93);
}

pub fn unknown32(self: @This()) u32 {
    return self.row.at(u32, 96);
}

pub fn unknown33(self: @This()) u32 {
    return self.row.at(u32, 100);
}

pub fn unknown34(self: @This()) u8 {
    return self.row.at(u8, 104);
}

pub fn unknown35(self: @This()) u8 {
    return self.row.at(u8, 105);
}

pub fn unknown36(self: @This()) u32 {
    return self.row.at(u32, 108);
}

pub fn unknown37(self: @This()) u32 {
    return self.row.at(u32, 112);
}

pub fn unknown38(self: @This()) u8 {
    return self.row.at(u8, 116);
}

pub fn unknown39(self: @This()) u8 {
    return self.row.at(u8, 117);
}

pub fn unknown40(self: @This()) u32 {
    return self.row.at(u32, 120);
}

pub fn unknown41(self: @This()) u32 {
    return self.row.at(u32, 124);
}

pub fn unknown42(self: @This()) u8 {
    return self.row.at(u8, 128);
}

pub fn unknown43(self: @This()) u8 {
    return self.row.at(u8, 129);
}

pub fn unknown44(self: @This()) u32 {
    return self.row.at(u32, 132);
}

pub fn unknown45(self: @This()) u32 {
    return self.row.at(u32, 136);
}

pub fn unknown46(self: @This()) u8 {
    return self.row.at(u8, 140);
}

pub fn unknown47(self: @This()) u8 {
    return self.row.at(u8, 141);
}

pub fn unknown48(self: @This()) u32 {
    return self.row.at(u32, 144);
}

pub fn unknown49(self: @This()) u32 {
    return self.row.at(u32, 148);
}

pub fn unknown50(self: @This()) u8 {
    return self.row.at(u8, 152);
}

pub fn unknown51(self: @This()) u8 {
    return self.row.at(u8, 153);
}

pub fn unknown52(self: @This()) u32 {
    return self.row.at(u32, 156);
}

pub fn unknown53(self: @This()) u32 {
    return self.row.at(u32, 160);
}

pub fn unknown54(self: @This()) u8 {
    return self.row.at(u8, 164);
}

pub fn unknown55(self: @This()) u8 {
    return self.row.at(u8, 165);
}

pub fn unknown56(self: @This()) u32 {
    return self.row.at(u32, 168);
}

pub fn unknown57(self: @This()) u32 {
    return self.row.at(u32, 172);
}

pub fn unknown58(self: @This()) u8 {
    return self.row.at(u8, 176);
}

pub fn unknown59(self: @This()) u8 {
    return self.row.at(u8, 177);
}

pub fn unknown60(self: @This()) u32 {
    return self.row.at(u32, 180);
}

pub fn unknown61(self: @This()) u32 {
    return self.row.at(u32, 184);
}

pub fn unknown62(self: @This()) u8 {
    return self.row.at(u8, 188);
}

pub fn unknown63(self: @This()) u8 {
    return self.row.at(u8, 189);
}

pub fn unknown64(self: @This()) u32 {
    return self.row.at(u32, 192);
}

pub fn unknown65(self: @This()) u32 {
    return self.row.at(u32, 196);
}

pub fn unknown66(self: @This()) u8 {
    return self.row.at(u8, 200);
}

pub fn unknown67(self: @This()) u8 {
    return self.row.at(u8, 201);
}

pub fn unknown68(self: @This()) u32 {
    return self.row.at(u32, 204);
}

pub fn unknown69(self: @This()) u32 {
    return self.row.at(u32, 208);
}

pub fn unknown70(self: @This()) u8 {
    return self.row.at(u8, 212);
}

pub fn unknown71(self: @This()) u8 {
    return self.row.at(u8, 213);
}

pub fn unknown72(self: @This()) u32 {
    return self.row.at(u32, 216);
}

pub fn unknown73(self: @This()) u32 {
    return self.row.at(u32, 220);
}

pub fn unknown74(self: @This()) u8 {
    return self.row.at(u8, 224);
}

pub fn unknown75(self: @This()) u8 {
    return self.row.at(u8, 225);
}

pub fn unknown76(self: @This()) u32 {
    return self.row.at(u32, 228);
}

pub fn unknown77(self: @This()) u32 {
    return self.row.at(u32, 232);
}

pub fn unknown78(self: @This()) u8 {
    return self.row.at(u8, 236);
}

pub fn unknown79(self: @This()) u8 {
    return self.row.at(u8, 237);
}

pub fn unknown80(self: @This()) u32 {
    return self.row.at(u32, 240);
}

pub fn unknown81(self: @This()) u32 {
    return self.row.at(u32, 244);
}

pub fn unknown82(self: @This()) u8 {
    return self.row.at(u8, 248);
}

pub fn unknown83(self: @This()) u8 {
    return self.row.at(u8, 249);
}

pub fn unknown84(self: @This()) u32 {
    return self.row.at(u32, 252);
}

pub fn unknown85(self: @This()) u32 {
    return self.row.at(u32, 256);
}

pub fn unknown86(self: @This()) u8 {
    return self.row.at(u8, 260);
}

pub fn unknown87(self: @This()) u8 {
    return self.row.at(u8, 261);
}

pub fn unknown88(self: @This()) u32 {
    return self.row.at(u32, 264);
}

pub fn unknown89(self: @This()) u32 {
    return self.row.at(u32, 268);
}

pub fn unknown90(self: @This()) u8 {
    return self.row.at(u8, 272);
}

pub fn unknown91(self: @This()) u8 {
    return self.row.at(u8, 273);
}

pub fn unknown92(self: @This()) u32 {
    return self.row.at(u32, 276);
}

pub fn unknown93(self: @This()) u32 {
    return self.row.at(u32, 280);
}

pub fn unknown94(self: @This()) u8 {
    return self.row.at(u8, 284);
}

pub fn unknown95(self: @This()) u8 {
    return self.row.at(u8, 285);
}

pub fn unknown96(self: @This()) u32 {
    return self.row.at(u32, 288);
}

pub fn unknown97(self: @This()) u32 {
    return self.row.at(u32, 292);
}

pub fn unknown98(self: @This()) u8 {
    return self.row.at(u8, 296);
}

pub fn unknown99(self: @This()) u8 {
    return self.row.at(u8, 297);
}

pub fn unknown100(self: @This()) u32 {
    return self.row.at(u32, 300);
}

pub fn unknown101(self: @This()) u32 {
    return self.row.at(u32, 304);
}

pub fn unknown102(self: @This()) u8 {
    return self.row.at(u8, 308);
}

pub fn unknown103(self: @This()) u8 {
    return self.row.at(u8, 309);
}

pub fn unknown104(self: @This()) u32 {
    return self.row.at(u32, 312);
}

pub fn unknown105(self: @This()) u32 {
    return self.row.at(u32, 316);
}

pub fn unknown106(self: @This()) u8 {
    return self.row.at(u8, 320);
}

pub fn unknown107(self: @This()) u8 {
    return self.row.at(u8, 321);
}

pub fn unknown108(self: @This()) u32 {
    return self.row.at(u32, 324);
}

pub fn unknown109(self: @This()) u32 {
    return self.row.at(u32, 328);
}

pub fn unknown110(self: @This()) u8 {
    return self.row.at(u8, 332);
}

pub fn unknown111(self: @This()) u8 {
    return self.row.at(u8, 333);
}

pub fn unknown112(self: @This()) u32 {
    return self.row.at(u32, 336);
}

pub fn unknown113(self: @This()) u32 {
    return self.row.at(u32, 340);
}

pub fn unknown114(self: @This()) u8 {
    return self.row.at(u8, 344);
}

pub fn unknown115(self: @This()) u8 {
    return self.row.at(u8, 345);
}

pub fn unknown116(self: @This()) u32 {
    return self.row.at(u32, 348);
}

pub fn unknown117(self: @This()) u32 {
    return self.row.at(u32, 352);
}

pub fn unknown118(self: @This()) u8 {
    return self.row.at(u8, 356);
}

pub fn unknown119(self: @This()) u8 {
    return self.row.at(u8, 357);
}

pub fn unknown120(self: @This()) u32 {
    return self.row.at(u32, 360);
}

pub fn unknown121(self: @This()) u32 {
    return self.row.at(u32, 364);
}

pub fn unknown122(self: @This()) u8 {
    return self.row.at(u8, 368);
}

pub fn unknown123(self: @This()) u8 {
    return self.row.at(u8, 369);
}

pub fn unknown124(self: @This()) u32 {
    return self.row.at(u32, 372);
}

pub fn unknown125(self: @This()) u32 {
    return self.row.at(u32, 376);
}

pub fn unknown126(self: @This()) u8 {
    return self.row.at(u8, 380);
}

pub fn unknown127(self: @This()) u8 {
    return self.row.at(u8, 381);
}
