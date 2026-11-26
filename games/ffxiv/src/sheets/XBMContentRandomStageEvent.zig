//! `XBMContentRandomStageEvent`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const XBMContentRandomStageEvent = @This();

pub const sheet_name = "XBMContentRandomStageEvent";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xd870e208;
pub const Sheet = excel.Typed(XBMContentRandomStageEvent);

row: excel.Row,

/// Links to `XBMRandomStageEvent`.
pub fn randomStageEvent(self: @This()) excel.Link(sheets.XBMRandomStageEvent) {
    return .of(self.row.at(u16, 0));
}
