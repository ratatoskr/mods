//! `VVDData`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const VVDData = @This();

pub const sheet_name = "VVDData";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x441a6f36;
pub const Sheet = excel.Typed(VVDData);

row: excel.Row,

/// Links to `ContentFinderCondition`.
pub fn contentFinderCondition(self: @This()) excel.Link(sheets.ContentFinderCondition) {
    return .of(self.row.at(u32, 0));
}

/// Links to `Item`.
pub fn currencyItem(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 4));
}

/// Links to `ContentExAction`.
pub fn contentExAction(self: @This()) excel.Link(sheets.ContentExAction) {
    return .of(self.row.at(u32, 8));
}

/// Links to `Quest`.
pub fn unlockQuest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 12));
}

/// RowId of VVDRouteData and VVDNotebookSeries
pub fn series(self: @This()) u8 {
    return self.row.at(u8, 16);
}

/// Sequence inside of the series.
pub fn sequence(self: @This()) u8 {
    return self.row.at(u8, 17);
}

/// Links to `VVDVoteRoute`.
pub fn routeData(self: @This()) excel.Link(sheets.VVDVoteRoute) {
    return .of(self.row.at(u8, 18));
}
