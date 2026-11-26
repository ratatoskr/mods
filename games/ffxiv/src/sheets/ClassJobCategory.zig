//! `ClassJobCategory`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ClassJobCategory = @This();

pub const sheet_name = "ClassJobCategory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x6733e334;
pub const Sheet = excel.Typed(ClassJobCategory);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn adv(self: @This()) bool {
    return self.row.at(u8, 4) != 0;
}

pub fn gla(self: @This()) bool {
    return self.row.at(u8, 5) != 0;
}

pub fn pgl(self: @This()) bool {
    return self.row.at(u8, 6) != 0;
}

pub fn mrd(self: @This()) bool {
    return self.row.at(u8, 7) != 0;
}

pub fn lnc(self: @This()) bool {
    return self.row.at(u8, 8) != 0;
}

pub fn arc(self: @This()) bool {
    return self.row.at(u8, 9) != 0;
}

pub fn cnj(self: @This()) bool {
    return self.row.at(u8, 10) != 0;
}

pub fn thm(self: @This()) bool {
    return self.row.at(u8, 11) != 0;
}

pub fn crp(self: @This()) bool {
    return self.row.at(u8, 12) != 0;
}

pub fn bsm(self: @This()) bool {
    return self.row.at(u8, 13) != 0;
}

pub fn arm(self: @This()) bool {
    return self.row.at(u8, 14) != 0;
}

pub fn gsm(self: @This()) bool {
    return self.row.at(u8, 15) != 0;
}

pub fn ltw(self: @This()) bool {
    return self.row.at(u8, 16) != 0;
}

pub fn wvr(self: @This()) bool {
    return self.row.at(u8, 17) != 0;
}

pub fn alc(self: @This()) bool {
    return self.row.at(u8, 18) != 0;
}

pub fn cul(self: @This()) bool {
    return self.row.at(u8, 19) != 0;
}

pub fn min(self: @This()) bool {
    return self.row.at(u8, 20) != 0;
}

pub fn btn(self: @This()) bool {
    return self.row.at(u8, 21) != 0;
}

pub fn fsh(self: @This()) bool {
    return self.row.at(u8, 22) != 0;
}

pub fn pld(self: @This()) bool {
    return self.row.at(u8, 23) != 0;
}

pub fn mnk(self: @This()) bool {
    return self.row.at(u8, 24) != 0;
}

pub fn war(self: @This()) bool {
    return self.row.at(u8, 25) != 0;
}

pub fn drg(self: @This()) bool {
    return self.row.at(u8, 26) != 0;
}

pub fn brd(self: @This()) bool {
    return self.row.at(u8, 27) != 0;
}

pub fn whm(self: @This()) bool {
    return self.row.at(u8, 28) != 0;
}

pub fn blm(self: @This()) bool {
    return self.row.at(u8, 29) != 0;
}

pub fn acn(self: @This()) bool {
    return self.row.at(u8, 30) != 0;
}

pub fn smn(self: @This()) bool {
    return self.row.at(u8, 31) != 0;
}

pub fn sch(self: @This()) bool {
    return self.row.at(u8, 32) != 0;
}

pub fn rog(self: @This()) bool {
    return self.row.at(u8, 33) != 0;
}

pub fn nin(self: @This()) bool {
    return self.row.at(u8, 34) != 0;
}

pub fn mch(self: @This()) bool {
    return self.row.at(u8, 35) != 0;
}

pub fn drk(self: @This()) bool {
    return self.row.at(u8, 36) != 0;
}

pub fn ast(self: @This()) bool {
    return self.row.at(u8, 37) != 0;
}

pub fn sam(self: @This()) bool {
    return self.row.at(u8, 38) != 0;
}

pub fn rdm(self: @This()) bool {
    return self.row.at(u8, 39) != 0;
}

pub fn blu(self: @This()) bool {
    return self.row.at(u8, 40) != 0;
}

pub fn gnb(self: @This()) bool {
    return self.row.at(u8, 41) != 0;
}

pub fn dnc(self: @This()) bool {
    return self.row.at(u8, 42) != 0;
}

pub fn rpr(self: @This()) bool {
    return self.row.at(u8, 43) != 0;
}

pub fn sge(self: @This()) bool {
    return self.row.at(u8, 44) != 0;
}

pub fn vpr(self: @This()) bool {
    return self.row.at(u8, 45) != 0;
}

pub fn pct(self: @This()) bool {
    return self.row.at(u8, 46) != 0;
}

pub fn bst(self: @This()) bool {
    return self.row.at(u8, 47) != 0;
}

pub fn unknown1(self: @This()) bool {
    return self.row.at(u8, 48) != 0;
}

pub fn unknown2(self: @This()) bool {
    return self.row.at(u8, 49) != 0;
}
