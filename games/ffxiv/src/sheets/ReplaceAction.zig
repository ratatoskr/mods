//! `ReplaceAction`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ReplaceAction = @This();

pub const sheet_name = "ReplaceAction";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xfdfdd803;
pub const Sheet = excel.Typed(ReplaceAction);

row: excel.Row,

/// Links to `Action`.
pub fn action(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(i32, 0));
}

pub const replace_actions_len = 4;
/// Links to `Action`.
pub fn replaceActions(self: @This(), n0: usize) excel.Link(sheets.Action) {
    return .of(self.row.at(i32, offsets_1[n0]));
}

/// Links by `Type1`: 2 to `Status`, 3 to `Trait`, 4 to `Status`, 7 to `Status`, 12 to `Status`, 13 to `Status`.
pub fn param1(self: @This()) i16 {
    return self.row.at(i16, 20);
}

/// Links by `Type2`: 2 to `Status`, 3 to `Trait`, 4 to `Status`, 7 to `Status`, 12 to `Status`, 13 to `Status`.
pub fn param2(self: @This()) i16 {
    return self.row.at(i16, 22);
}

/// Links by `Type3`: 2 to `Status`, 3 to `Trait`, 4 to `Status`, 7 to `Status`, 12 to `Status`, 13 to `Status`.
pub fn param3(self: @This()) i16 {
    return self.row.at(i16, 24);
}

/// Links by `Type4`: 2 to `Status`, 3 to `Trait`, 4 to `Status`, 7 to `Status`, 12 to `Status`, 13 to `Status`.
pub fn param4(self: @This()) i16 {
    return self.row.at(i16, 26);
}

pub fn type1(self: @This()) i8 {
    return self.row.at(i8, 28);
}

pub fn type2(self: @This()) i8 {
    return self.row.at(i8, 29);
}

pub fn type3(self: @This()) i8 {
    return self.row.at(i8, 30);
}

pub fn type4(self: @This()) i8 {
    return self.row.at(i8, 31);
}

pub fn replaceSettable(self: @This()) i8 {
    return self.row.at(i8, 32);
}

pub fn unknown_70(self: @This()) bool {
    return self.row.bitAt(33, 0);
}

const offsets_1 = [4]u16{ 4, 8, 12, 16 };
