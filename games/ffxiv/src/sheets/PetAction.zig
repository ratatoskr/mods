//! `PetAction`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PetAction = @This();

pub const sheet_name = "PetAction";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5e492849;
pub const Sheet = excel.Typed(PetAction);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "Description", "Icon", "Action", "Pet", "MasterOrder", "DisableOrder", "Unknown0" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 8);
}

/// Links to `Action`.
pub fn action(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(u16, 12));
}

/// Links to `Pet`.
pub fn pet(self: @This()) excel.Link(sheets.Pet) {
    return .of(self.row.at(u8, 14));
}

pub fn masterOrder(self: @This()) bool {
    return self.row.bitAt(15, 0);
}

pub fn disableOrder(self: @This()) bool {
    return self.row.bitAt(15, 1);
}

pub fn unknown0(self: @This()) bool {
    return self.row.bitAt(15, 2);
}
