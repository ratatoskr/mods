//! `TopicSelect`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TopicSelect = @This();

pub const sheet_name = "TopicSelect";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc312c89f;
pub const Sheet = excel.Typed(TopicSelect);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "Unknown2", "Unknown1", "Unknown0", "Shop[0]", "Shop[1]", "Shop[2]", "Shop[3]", "Shop[4]", "Shop[5]", "Shop[6]", "Shop[7]", "Shop[8]", "Shop[9]" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub const shop_len = 10;
/// Links to `SpecialShop`, `GilShop` or `PreHandler`, whichever has the row.
pub fn shop(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_1[n0]);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 44);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 46);
}

pub fn unknown2(self: @This()) bool {
    return self.row.bitAt(47, 0);
}

const offsets_1 = [10]u16{ 4, 8, 12, 16, 20, 24, 28, 32, 36, 40 };
