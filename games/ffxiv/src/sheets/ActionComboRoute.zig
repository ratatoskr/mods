//! `ActionComboRoute`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ActionComboRoute = @This();

pub const sheet_name = "ActionComboRoute";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe732fd5b;
pub const Sheet = excel.Typed(ActionComboRoute);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "Unknown3", "Action[0]", "Action[1]", "Action[2]", "Action[3]", "Action[4]", "Action[5]", "Action[6]", "Unknown4" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub const action_len = 7;
/// Links to `Action`.
pub fn action(self: @This(), n0: usize) excel.Link(sheets.Action) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

pub fn unknown3(self: @This()) i8 {
    return self.row.at(i8, 18);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(19, 0);
}

const offsets_1 = [7]u16{ 4, 6, 8, 10, 12, 14, 16 };
