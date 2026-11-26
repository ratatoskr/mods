//! `HousingTrainingDoll`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Base`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HousingTrainingDoll = @This();

pub const sheet_name = "HousingTrainingDoll";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdbf43666;
pub const Sheet = excel.Typed(HousingTrainingDoll);

row: excel.Row,

/// Links to `BNpcBase`.
pub fn base(self: @This()) excel.Link(sheets.BNpcBase) {
    return .of(self.row.at(u32, 0));
}
