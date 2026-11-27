//! `DawnQuestMember`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Member`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DawnQuestMember = @This();

pub const sheet_name = "DawnQuestMember";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x9a909078;
pub const Sheet = excel.Typed(DawnQuestMember);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Unknown1", "Member", "BigImageOld", "BigImageNew", "Class" };

/// Links to `ENpcResident`.
pub fn member(self: @This()) excel.Link(sheets.ENpcResident) {
    return .of(self.row.at(u32, 0));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn bigImageOld(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn bigImageNew(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 14);
}

/// Links to `DawnMemberUIParam`.
pub fn class(self: @This()) excel.Link(sheets.DawnMemberUIParam) {
    return .of(self.row.at(u8, 15));
}
