//! `CharaMakeClassEquip`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CharaMakeClassEquip = @This();

pub const sheet_name = "CharaMakeClassEquip";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x41dafacb;
pub const Sheet = excel.Typed(CharaMakeClassEquip);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Helmet", "Top", "Glove", "Down", "Shoes", "Weapon", "SubWeapon", "Class" };

/// A model id, packed.
pub fn helmet(self: @This()) u64 {
    return self.row.at(u64, 0);
}

/// A model id, packed.
pub fn top(self: @This()) u64 {
    return self.row.at(u64, 8);
}

/// A model id, packed.
pub fn glove(self: @This()) u64 {
    return self.row.at(u64, 16);
}

/// A model id, packed.
pub fn down(self: @This()) u64 {
    return self.row.at(u64, 24);
}

/// A model id, packed.
pub fn shoes(self: @This()) u64 {
    return self.row.at(u64, 32);
}

/// A model id, packed.
pub fn weapon(self: @This()) u64 {
    return self.row.at(u64, 40);
}

/// A model id, packed.
pub fn subWeapon(self: @This()) u64 {
    return self.row.at(u64, 48);
}

/// Links to `ClassJob`.
pub fn class(self: @This()) excel.Link(sheets.ClassJob) {
    return .of(self.row.at(i32, 56));
}
