//! `FishingRecordType`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Addon`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const FishingRecordType = @This();

pub const sheet_name = "FishingRecordType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x2c75ba5d;
pub const Sheet = excel.Typed(FishingRecordType);

row: excel.Row,

/// Links to `Addon`.
pub fn addon(self: @This()) excel.Link(sheets.Addon) {
    return .of(self.row.at(i32, 0));
}

pub fn rankBRequirement(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn rankARequirement(self: @This()) u16 {
    return self.row.at(u16, 6);
}

pub fn rankAARequirement(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn rankAAARequirement(self: @This()) u16 {
    return self.row.at(u16, 10);
}

pub fn rankSRequirement(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn isSpearfishing(self: @This()) u8 {
    return self.row.at(u8, 14);
}
