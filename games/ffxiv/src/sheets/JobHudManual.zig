//! `JobHudManual`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Action`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const JobHudManual = @This();

pub const sheet_name = "JobHudManual";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xa5aa10b4;
pub const Sheet = excel.Typed(JobHudManual);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown1", "Unknown_70", "Unknown2", "Action", "Unknown3", "Unknown0", "Guide" };

/// Links to `Action`.
pub fn action(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(u32, 0));
}

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// Links to `Guide`.
pub fn guide(self: @This()) excel.Link(sheets.Guide) {
    return .of(self.row.at(u16, 8));
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 10);
}

pub fn unknown_70(self: @This()) u8 {
    return self.row.at(u8, 11);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 12);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 13);
}
