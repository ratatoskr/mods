//! `CompleteJournal`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CompleteJournal = @This();

pub const sheet_name = "CompleteJournal";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x8741e36a;
pub const Sheet = excel.Typed(CompleteJournal);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 8);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 12);
}

pub const cutscene_len = 24;
/// Links to `Cutscene`.
pub fn cutscene(self: @This(), n0: usize) excel.Link(sheets.Cutscene) {
    return .of(self.row.at(i32, offsets_1[n0]));
}

pub fn requiredLevel(self: @This()) u16 {
    return self.row.at(u16, 112);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 114);
}

const offsets_1 = [24]u16{ 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 68, 72, 76, 80, 84, 88, 92, 96, 100, 104, 108 };
