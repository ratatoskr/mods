//! `WKSMissionToDoEvalutionItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSMissionToDoEvalutionItem = @This();

pub const sheet_name = "WKSMissionToDoEvalutionItem";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xd870e208;
pub const Sheet = excel.Typed(WKSMissionToDoEvalutionItem);

row: excel.Row,

/// Links to `WKSItemInfo`.
pub fn item(self: @This()) excel.Link(sheets.WKSItemInfo) {
    return .of(self.row.at(u16, 0));
}
