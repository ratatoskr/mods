//! `AkatsukiNote`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `ListName`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AkatsukiNote = @This();

pub const sheet_name = "AkatsukiNote";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xb8742590;
pub const Sheet = excel.Typed(AkatsukiNote);

row: excel.Row,

pub fn unknown0(self: @This()) i32 {
    return self.row.at(i32, 0);
}

pub fn unknown1(self: @This()) i32 {
    return self.row.at(i32, 4);
}

/// Links to `AkatsukiNoteString`.
pub fn listName(self: @This()) excel.Link(sheets.AkatsukiNoteString) {
    return .of(self.row.at(i32, 8));
}

/// Links to `Quest`.
pub fn unlockOnQuest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(i32, 12));
}

pub fn unknown4(self: @This()) i32 {
    return self.row.at(i32, 16);
}

/// Links to `AkatsukiNoteString`.
pub fn title(self: @This()) excel.Link(sheets.AkatsukiNoteString) {
    return .of(self.row.at(i32, 20));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 24);
}

/// Links to `AkatsukiNoteString`.
pub fn subtitle(self: @This()) excel.Link(sheets.AkatsukiNoteString) {
    return .of(self.row.at(i32, 28));
}

/// Links to `AkatsukiNoteString`.
pub fn text(self: @This()) excel.Link(sheets.AkatsukiNoteString) {
    return .of(self.row.at(i32, 32));
}
