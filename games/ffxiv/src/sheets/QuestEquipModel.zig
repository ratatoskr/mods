//! `QuestEquipModel`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const QuestEquipModel = @This();

pub const sheet_name = "QuestEquipModel";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x3167959f;
pub const Sheet = excel.Typed(QuestEquipModel);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Slot", "Model" };

/// A model id, packed.
pub fn model(self: @This()) u64 {
    return self.row.at(u64, 0);
}

pub fn slot(self: @This()) i8 {
    return self.row.at(i8, 8);
}
