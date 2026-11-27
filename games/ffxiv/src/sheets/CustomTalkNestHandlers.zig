//! `CustomTalkNestHandlers`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CustomTalkNestHandlers = @This();

pub const sheet_name = "CustomTalkNestHandlers";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xdbf43666;
pub const Sheet = excel.Typed(CustomTalkNestHandlers);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{"NestHandler"};

/// Links to `GilShop`, `SpecialShop`, `DisposalShop` or `ContentEntry`, whichever has the row.
pub fn nestHandler(self: @This()) u32 {
    return self.row.at(u32, 0);
}
