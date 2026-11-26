//! `RacingChocoboNameInfo`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const RacingChocoboNameInfo = @This();

pub const sheet_name = "RacingChocoboNameInfo";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc0f1f5a8;
pub const Sheet = excel.Typed(RacingChocoboNameInfo);

row: excel.Row,

pub const name_len = 3;
/// Links to `RacingChocoboName`.
pub fn name(self: @This(), n0: usize) excel.Link(sheets.RacingChocoboName) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

pub fn unknown4(self: @This()) u16 {
    return self.row.at(u16, 6);
}

/// Links to `RacingChocoboNameCategory`.
pub fn racingChocoboNameCategory(self: @This()) excel.Link(sheets.RacingChocoboNameCategory) {
    return .of(self.row.at(u8, 8));
}

pub fn unknown0(self: @This()) bool {
    return self.row.at(u8, 9) != 0;
}

pub fn unknown1(self: @This()) bool {
    return self.row.at(u8, 10) != 0;
}

pub fn unknown2(self: @This()) bool {
    return self.row.at(u8, 11) != 0;
}

pub fn unknown3(self: @This()) bool {
    return self.row.at(u8, 12) != 0;
}

const offsets_1 = [3]u16{ 0, 2, 4 };
