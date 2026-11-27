//! `Tribe`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Feminine`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Tribe = @This();

pub const sheet_name = "Tribe";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe74759fb;
pub const Sheet = excel.Typed(Tribe);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Masculine", "Feminine", "Hp", "Mp", "STR", "VIT", "DEX", "INT", "MND", "PIE" };

pub fn masculine(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn feminine(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn hp(self: @This()) i8 {
    return self.row.at(i8, 8);
}

pub fn mp(self: @This()) i8 {
    return self.row.at(i8, 9);
}

pub fn str(self: @This()) i8 {
    return self.row.at(i8, 10);
}

pub fn vit(self: @This()) i8 {
    return self.row.at(i8, 11);
}

pub fn dex(self: @This()) i8 {
    return self.row.at(i8, 12);
}

pub fn int(self: @This()) i8 {
    return self.row.at(i8, 13);
}

pub fn mnd(self: @This()) i8 {
    return self.row.at(i8, 14);
}

pub fn pie(self: @This()) i8 {
    return self.row.at(i8, 15);
}
