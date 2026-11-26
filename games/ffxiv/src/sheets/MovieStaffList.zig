//! `MovieStaffList`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MovieStaffList = @This();

pub const sheet_name = "MovieStaffList";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc3212d0e;
pub const Sheet = excel.Typed(MovieStaffList);

row: excel.Row,

pub fn startTime(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn endTime(self: @This()) f32 {
    return self.row.at(f32, 4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn image(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn unknown0(self: @This()) i8 {
    return self.row.at(i8, 12);
}
