//! `MJICraftworksPopularityType`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Ratio`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJICraftworksPopularityType = @This();

pub const sheet_name = "MJICraftworksPopularityType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd870e208;
pub const Sheet = excel.Typed(MJICraftworksPopularityType);

row: excel.Row,

pub fn ratio(self: @This()) u16 {
    return self.row.at(u16, 0);
}
