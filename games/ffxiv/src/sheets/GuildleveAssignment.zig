//! `GuildleveAssignment`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GuildleveAssignment = @This();

pub const sheet_name = "GuildleveAssignment";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x129d93fa;
pub const Sheet = excel.Typed(GuildleveAssignment);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Type", "Unknown0", "AssignmentTalk", "Quest[0]", "Quest[1]", "Unknown2", "Unknown3", "Unknown4", "Unknown5", "Unknown6", "RequiredGrandCompanyRank" };

pub fn @"type"(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `GuildleveAssignmentTalk`.
pub fn assignmentTalk(self: @This()) excel.Link(sheets.GuildleveAssignmentTalk) {
    return .of(self.row.at(u32, 4));
}

pub const quest_len = 2;
/// Links to `Quest`.
pub fn quest(self: @This(), n0: usize) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 16);
}

pub fn requiredGrandCompanyRank(self: @This()) u8 {
    return self.row.at(u8, 17);
}

pub fn unknown2(self: @This()) bool {
    return self.row.bitAt(18, 0);
}

pub fn unknown3(self: @This()) bool {
    return self.row.bitAt(18, 1);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(18, 2);
}

pub fn unknown5(self: @This()) bool {
    return self.row.bitAt(18, 3);
}

pub fn unknown6(self: @This()) bool {
    return self.row.bitAt(18, 4);
}

const offsets_1 = [2]u16{ 8, 12 };
