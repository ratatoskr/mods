//! `SpearfishingRecordPage`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SpearfishingRecordPage = @This();

pub const sheet_name = "SpearfishingRecordPage";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe72da550;
pub const Sheet = excel.Typed(SpearfishingRecordPage);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown1", "Unknown2", "Unknown3", "PlaceName", "Image", "Unknown0", "Unknown4" };

/// Links to `PlaceName`.
pub fn placeName(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(i32, 0));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn image(self: @This()) i32 {
    return self.row.at(i32, 4);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 10);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 11);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 12);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 13);
}
