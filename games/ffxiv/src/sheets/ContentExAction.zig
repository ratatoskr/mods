//! `ContentExAction`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ContentExAction = @This();

pub const sheet_name = "ContentExAction";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x8690a89e;
pub const Sheet = excel.Typed(ContentExAction);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name[0]", "Name[1]", "Charges[0]", "Charges[1]" };

pub const name_len = 2;
/// Links to `Action`.
pub fn name(self: @This(), n0: usize) excel.Link(sheets.Action) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

pub const charges_len = 2;
pub fn charges(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_2[n0]);
}

const offsets_1 = [2]u16{ 0, 4 };
const offsets_2 = [2]u16{ 8, 9 };
