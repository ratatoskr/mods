//! `FishingRecordTypeTransient`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Image`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const FishingRecordTypeTransient = @This();

pub const sheet_name = "FishingRecordTypeTransient";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xda365c51;
pub const Sheet = excel.Typed(FishingRecordTypeTransient);

row: excel.Row,

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn image(self: @This()) i32 {
    return self.row.at(i32, 0);
}
