//! `EquipRaceCategory`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EquipRaceCategory = @This();

pub const sheet_name = "EquipRaceCategory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf914b198;
pub const Sheet = excel.Typed(EquipRaceCategory);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Hyur", "Elezen", "Lalafell", "Miqote", "Roegadyn", "AuRa", "Hrothgar", "Viera", "Male", "Female" };

pub fn hyur(self: @This()) bool {
    return self.row.at(u8, 0) != 0;
}

pub fn elezen(self: @This()) bool {
    return self.row.at(u8, 1) != 0;
}

pub fn lalafell(self: @This()) bool {
    return self.row.at(u8, 2) != 0;
}

pub fn miqote(self: @This()) bool {
    return self.row.at(u8, 3) != 0;
}

pub fn roegadyn(self: @This()) bool {
    return self.row.at(u8, 4) != 0;
}

pub fn auRa(self: @This()) bool {
    return self.row.at(u8, 5) != 0;
}

pub fn hrothgar(self: @This()) bool {
    return self.row.at(u8, 6) != 0;
}

pub fn viera(self: @This()) bool {
    return self.row.at(u8, 7) != 0;
}

pub fn male(self: @This()) bool {
    return self.row.bitAt(8, 0);
}

pub fn female(self: @This()) bool {
    return self.row.bitAt(8, 1);
}
