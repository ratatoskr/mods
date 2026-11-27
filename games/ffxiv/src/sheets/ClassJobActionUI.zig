//! `ClassJobActionUI`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ClassJobActionUI = @This();

pub const sheet_name = "ClassJobActionUI";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x9c44e91d;
pub const Sheet = excel.Typed(ClassJobActionUI);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "UpgradeAction", "Unknown3", "Unknown4", "BaseAction", "ComboTreeLayout", "GroupedCell", "Category" };

/// Links to `Action`.
pub fn upgradeAction(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(u32, 0));
}

/// Links to `Action`.
pub fn baseAction(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(u32, 4));
}

/// Used to position the action within a combo tree diagram. Non-zero digits identify branches within the combo (eg, Hakaze -> Shifu -> Kasha is 100 -> 120 -> 121)
pub fn comboTreeLayout(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 10);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 11);
}

/// Links to `ClassJobActionUICategory`.
pub fn category(self: @This()) excel.Link(sheets.ClassJobActionUICategory) {
    return .of(self.row.at(u8, 12));
}

/// Currently only used for MNK actions; displays a set of actions in a shared rectangular cell instead of a tree.
pub fn groupedCell(self: @This()) bool {
    return self.row.bitAt(13, 0);
}
