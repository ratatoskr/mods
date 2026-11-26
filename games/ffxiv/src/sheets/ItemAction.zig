//! `ItemAction`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ItemAction = @This();

pub const sheet_name = "ItemAction";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xb1f26af0;
pub const Sheet = excel.Typed(ItemAction);

row: excel.Row,

/// Links to `Action`.
pub fn action(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(u16, 0));
}

pub const data_len = 9;
pub fn data(self: @This(), n0: usize) u16 {
    return self.row.at(u16, offsets_1[n0]);
}

pub const data_hq_len = 9;
pub fn dataHQ(self: @This(), n0: usize) u16 {
    return self.row.at(u16, offsets_2[n0]);
}

pub fn condLv(self: @This()) u8 {
    return self.row.at(u8, 38);
}

pub fn condBattle(self: @This()) bool {
    return self.row.bitAt(39, 0);
}

pub fn condPVP(self: @This()) bool {
    return self.row.bitAt(39, 1);
}

pub fn condPVPOnly(self: @This()) bool {
    return self.row.bitAt(39, 2);
}

const offsets_1 = [9]u16{ 2, 4, 6, 8, 10, 12, 14, 16, 18 };
const offsets_2 = [9]u16{ 20, 22, 24, 26, 28, 30, 32, 34, 36 };
