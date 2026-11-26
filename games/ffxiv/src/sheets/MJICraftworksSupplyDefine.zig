//! `MJICraftworksSupplyDefine`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJICraftworksSupplyDefine = @This();

pub const sheet_name = "MJICraftworksSupplyDefine";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x1299950e;
pub const Sheet = excel.Typed(MJICraftworksSupplyDefine);

row: excel.Row,

pub fn ratio(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn supply(self: @This()) i16 {
    return self.row.at(i16, 2);
}
