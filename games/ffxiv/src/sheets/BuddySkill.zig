//! `BuddySkill`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BuddySkill = @This();

pub const sheet_name = "BuddySkill";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe3220ddc;
pub const Sheet = excel.Typed(BuddySkill);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "BuddyLevel", "IsActive", "Defender", "Attacker", "Healer" };

/// Links to `Trait` or `Action`, whichever has the row.
pub fn defender(self: @This()) u16 {
    return self.row.at(u16, 0);
}

/// Links to `Trait` or `Action`, whichever has the row.
pub fn attacker(self: @This()) u16 {
    return self.row.at(u16, 2);
}

/// Links to `Trait` or `Action`, whichever has the row.
pub fn healer(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn buddyLevel(self: @This()) u8 {
    return self.row.at(u8, 6);
}

pub fn isActive(self: @This()) bool {
    return self.row.bitAt(7, 0);
}
