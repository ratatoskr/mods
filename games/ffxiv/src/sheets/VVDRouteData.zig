//! `VVDRouteData`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `NotebookEntry`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const VVDRouteData = @This();

pub const sheet_name = "VVDRouteData";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xd870e208;
pub const Sheet = excel.Typed(VVDRouteData);

row: excel.Row,

/// Links to `VVDNotebookContents`.
pub fn notebookEntry(self: @This()) excel.Link(sheets.VVDNotebookContents) {
    return .of(self.row.at(u16, 0));
}
