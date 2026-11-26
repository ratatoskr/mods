//! `MKDTrait`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MKDTrait = @This();

pub const sheet_name = "MKDTrait";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc4352ccf;
pub const Sheet = excel.Typed(MKDTrait);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 8);
}

/// Links to `MKDSupportJob`.
pub fn mkdSupportJob(self: @This()) excel.Link(sheets.MKDSupportJob) {
    return .of(self.row.at(u8, 12));
}

pub fn levelUnlock(self: @This()) u8 {
    return self.row.at(u8, 13);
}
