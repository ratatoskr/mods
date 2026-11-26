//! `GeneralAction`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GeneralAction = @This();

pub const sheet_name = "GeneralAction";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x2d414d58;
pub const Sheet = excel.Typed(GeneralAction);

row: excel.Row,

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

pub fn unlockLink(self: @This()) u16 {
    return self.row.at(u16, 14);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 16);
}

pub fn recast(self: @This()) u8 {
    return self.row.at(u8, 17);
}

pub fn uiPriority(self: @This()) u8 {
    return self.row.at(u8, 18);
}

pub fn unknown2(self: @This()) bool {
    return self.row.bitAt(19, 0);
}

pub fn unknown1(self: @This()) bool {
    return self.row.bitAt(19, 1);
}
