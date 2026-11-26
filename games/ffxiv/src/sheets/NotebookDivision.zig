//! `NotebookDivision`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const NotebookDivision = @This();

pub const sheet_name = "NotebookDivision";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xfc3a5559;
pub const Sheet = excel.Typed(NotebookDivision);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `Quest`.
pub fn questUnlock(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 4));
}

/// Links to `NotebookDivisionCategory`.
pub fn notebookDivisionCategory(self: @This()) excel.Link(sheets.NotebookDivisionCategory) {
    return .of(self.row.at(u8, 8));
}

pub fn craftOpeningLevel(self: @This()) u8 {
    return self.row.at(u8, 9);
}

pub fn gatheringOpeningLevel(self: @This()) u8 {
    return self.row.at(u8, 10);
}

pub fn minimumQuestSequence(self: @This()) u8 {
    return self.row.at(u8, 11);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 12);
}

pub const secret_recipe_book_groups_len = 2;
/// Links to `SecretRecipeBookGroup`.
pub fn secretRecipeBookGroups(self: @This(), n0: usize) excel.Link(sheets.SecretRecipeBookGroup) {
    return .of(self.row.at(u8, offsets_1[n0]));
}

pub const allowed_craft_types_len = 8;
/// Index is CraftType
pub fn allowedCraftTypes(self: @This(), n0: usize) bool {
    return self.row.at(u8, offsets_2[n0]) != 0;
}

pub fn requiresSecretRecipeBookGroupUnlock(self: @This()) bool {
    return self.row.bitAt(23, 0);
}

const offsets_1 = [2]u16{ 13, 14 };
const offsets_2 = [8]u16{ 15, 16, 17, 18, 19, 20, 21, 22 };
