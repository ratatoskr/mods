//! `TutorialTank`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TutorialTank = @This();

pub const sheet_name = "TutorialTank";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5bfa8a4e;
pub const Sheet = excel.Typed(TutorialTank);

row: excel.Row,

pub fn image(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// Links to `Tutorial`.
pub fn objective(self: @This()) excel.Link(sheets.Tutorial) {
    return .of(self.row.at(u8, 4));
}
