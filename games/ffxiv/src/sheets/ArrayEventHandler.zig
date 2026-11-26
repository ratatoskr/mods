//! `ArrayEventHandler`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ArrayEventHandler = @This();

pub const sheet_name = "ArrayEventHandler";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xb404681e;
pub const Sheet = excel.Typed(ArrayEventHandler);

row: excel.Row,

pub const data_len = 16;
/// Links to `InstanceContentGuide`, `Story`, `Opening`, `CustomTalk`, `DefaultTalk`, `GilShop`, `Warp` or `Quest`, whichever has the row.
pub fn data(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_1[n0]);
}

const offsets_1 = [16]u16{ 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60 };
