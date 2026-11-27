//! `DawnMemberUIParam`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `ClassSingular`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DawnMemberUIParam = @This();

pub const sheet_name = "DawnMemberUIParam";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x7b44bc07;
pub const Sheet = excel.Typed(DawnMemberUIParam);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "ClassSingular", "Name", "VoiceLine", "ClassPlural" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn classPlural(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn voiceLine(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn classSingular(self: @This()) []const u8 {
    return self.row.stringAt(12);
}
