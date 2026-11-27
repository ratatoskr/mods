//! `GatheringSubCategory`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `FolkloreBook`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GatheringSubCategory = @This();

pub const sheet_name = "GatheringSubCategory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x6dac8145;
pub const Sheet = excel.Typed(GatheringSubCategory);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "GatheringType", "ClassJob", "Quest", "Division", "Item", "FolkloreBook", "Unknown0" };

pub fn folkloreBook(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `Quest`.
pub fn quest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 4));
}

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 8));
}

/// Links to `NotebookDivision`.
pub fn division(self: @This()) excel.Link(sheets.NotebookDivision) {
    return .of(self.row.at(u16, 12));
}

/// Links to `GatheringType`.
pub fn gatheringType(self: @This()) excel.Link(sheets.GatheringType) {
    return .of(self.row.at(u8, 14));
}

/// Links to `ClassJob`.
pub fn classJob(self: @This()) excel.Link(sheets.ClassJob) {
    return .of(self.row.at(u8, 15));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 16);
}
