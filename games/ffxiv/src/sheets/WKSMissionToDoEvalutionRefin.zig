//! `WKSMissionToDoEvalutionRefin`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSMissionToDoEvalutionRefin = @This();

pub const sheet_name = "WKSMissionToDoEvalutionRefin";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdc23efe7;
pub const Sheet = excel.Typed(WKSMissionToDoEvalutionRefin);

row: excel.Row,

pub fn lowPercent(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn midPercent(self: @This()) u16 {
    return self.row.at(u16, 2);
}

pub fn highPercent(self: @This()) u16 {
    return self.row.at(u16, 4);
}
