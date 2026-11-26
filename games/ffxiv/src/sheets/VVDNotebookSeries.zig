//! `VVDNotebookSeries`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const VVDNotebookSeries = @This();

pub const sheet_name = "VVDNotebookSeries";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x98d63a7b;
pub const Sheet = excel.Typed(VVDNotebookSeries);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub const contents_len = 13;
/// Links to `VVDNotebookContents`.
pub fn contents(self: @This(), n0: usize) excel.Link(sheets.VVDNotebookContents) {
    return .of(self.row.at(i32, offsets_1[n0]));
}

const offsets_1 = [13]u16{ 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52 };
