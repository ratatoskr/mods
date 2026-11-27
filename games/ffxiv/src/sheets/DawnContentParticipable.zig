//! `DawnContentParticipable`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `DawnQuestMember`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DawnContentParticipable = @This();

pub const sheet_name = "DawnContentParticipable";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xdcfd9eba;
pub const Sheet = excel.Typed(DawnContentParticipable);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{"DawnQuestMember"};

/// Links to `DawnQuestMember`.
pub fn dawnQuestMember(self: @This()) excel.Link(sheets.DawnQuestMember) {
    return .of(self.row.at(u8, 0));
}
