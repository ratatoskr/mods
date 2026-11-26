//! `ActionIndirection`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ActionIndirection = @This();

pub const sheet_name = "ActionIndirection";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc8901190;
pub const Sheet = excel.Typed(ActionIndirection);

row: excel.Row,

/// Links to `Action`.
pub fn name(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(i32, 0));
}

/// Links to `Action`.
pub fn previousComboAction(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(i32, 4));
}

/// Links to `ClassJob`.
pub fn classJob(self: @This()) excel.Link(sheets.ClassJob) {
    return .of(self.row.at(i8, 8));
}
