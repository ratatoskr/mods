//! `GoldSaucerArcadeMachine`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GoldSaucerArcadeMachine = @This();

pub const sheet_name = "GoldSaucerArcadeMachine";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xacb73d9e;
pub const Sheet = excel.Typed(GoldSaucerArcadeMachine);

row: excel.Row,

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn poor(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 9);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 10);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 11);
}

pub fn unknown5(self: @This()) u32 {
    return self.row.at(u32, 12);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn good(self: @This()) u32 {
    return self.row.at(u32, 16);
}

pub fn unknown6(self: @This()) u8 {
    return self.row.at(u8, 20);
}

pub fn unknown7(self: @This()) u8 {
    return self.row.at(u8, 21);
}

pub fn unknown8(self: @This()) u8 {
    return self.row.at(u8, 22);
}

pub fn unknown9(self: @This()) u8 {
    return self.row.at(u8, 23);
}

pub fn unknown10(self: @This()) u32 {
    return self.row.at(u32, 24);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn great(self: @This()) u32 {
    return self.row.at(u32, 28);
}

pub fn unknown11(self: @This()) u8 {
    return self.row.at(u8, 32);
}

pub fn unknown12(self: @This()) u8 {
    return self.row.at(u8, 33);
}

pub fn unknown13(self: @This()) u8 {
    return self.row.at(u8, 34);
}

pub fn unknown14(self: @This()) u8 {
    return self.row.at(u8, 35);
}

pub fn unknown15(self: @This()) u32 {
    return self.row.at(u32, 36);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn excellent(self: @This()) u32 {
    return self.row.at(u32, 40);
}

pub fn unknown16(self: @This()) u8 {
    return self.row.at(u8, 44);
}

pub fn unknown17(self: @This()) u8 {
    return self.row.at(u8, 45);
}

pub fn unknown18(self: @This()) u8 {
    return self.row.at(u8, 46);
}

pub fn unknown19(self: @This()) u8 {
    return self.row.at(u8, 47);
}

/// Shown in the Duty List.
pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(48);
}

/// Shown in the Duty List below Description.
pub fn payoutExplanation(self: @This()) []const u8 {
    return self.row.stringAt(52);
}

/// Shown in the Duty List.
pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(56);
}

/// Shown in the Duty List if this machine has multiple rounds.
pub fn totalPayoutText(self: @This()) []const u8 {
    return self.row.stringAt(60);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn failImage(self: @This()) u32 {
    return self.row.at(u32, 64);
}

pub fn unknown24(self: @This()) u32 {
    return self.row.at(u32, 68);
}

pub fn unknown25(self: @This()) u16 {
    return self.row.at(u16, 72);
}

pub fn unknown26(self: @This()) u8 {
    return self.row.at(u8, 74);
}

/// How long until the machine shuts down, in seconds.
pub fn timeout(self: @This()) u8 {
    return self.row.at(u8, 75);
}

pub fn unknown28(self: @This()) u8 {
    return self.row.at(u8, 76);
}

pub fn unknown29(self: @This()) u8 {
    return self.row.at(u8, 77);
}

pub fn unknown30(self: @This()) u8 {
    return self.row.at(u8, 78);
}

pub fn unknown31(self: @This()) u8 {
    return self.row.at(u8, 79);
}

pub fn unknown32(self: @This()) i8 {
    return self.row.at(i8, 80);
}

pub fn unknown33(self: @This()) i8 {
    return self.row.at(i8, 81);
}

pub fn unknown34(self: @This()) i8 {
    return self.row.at(i8, 82);
}

pub fn unknown35(self: @This()) i8 {
    return self.row.at(i8, 83);
}

pub fn unknown36(self: @This()) i8 {
    return self.row.at(i8, 84);
}

pub fn unknown37(self: @This()) i8 {
    return self.row.at(i8, 85);
}
