//! `SatisfactionBonusGuarantee`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SatisfactionBonusGuarantee = @This();

pub const sheet_name = "SatisfactionBonusGuarantee";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x69213275;
pub const Sheet = excel.Typed(SatisfactionBonusGuarantee);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "BonusDoH[0]", "BonusDoH[1]", "BonusDoL[0]", "BonusDoL[1]", "BonusFisher[0]", "BonusFisher[1]" };

pub const bonus_do_h_len = 2;
pub fn bonusDoH(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_1[n0]);
}

pub const bonus_do_l_len = 2;
pub fn bonusDoL(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_2[n0]);
}

pub const bonus_fisher_len = 2;
pub fn bonusFisher(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_3[n0]);
}

const offsets_1 = [2]u16{ 0, 1 };
const offsets_2 = [2]u16{ 2, 3 };
const offsets_3 = [2]u16{ 4, 5 };
