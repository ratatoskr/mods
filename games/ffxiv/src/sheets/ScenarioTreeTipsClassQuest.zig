//! `ScenarioTreeTipsClassQuest`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Quest`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ScenarioTreeTipsClassQuest = @This();

pub const sheet_name = "ScenarioTreeTipsClassQuest";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xae1d30a7;
pub const Sheet = excel.Typed(ScenarioTreeTipsClassQuest);

row: excel.Row,

/// Links to `Quest`.
pub fn quest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 0));
}

/// Links to `Quest`.
pub fn requiredQuest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 4));
}

pub fn requiredLevel(self: @This()) u16 {
    return self.row.at(u16, 8);
}

/// Links to `ExVersion`.
pub fn requiredExpansion(self: @This()) excel.Link(sheets.ExVersion) {
    return .of(self.row.at(u8, 10));
}

pub fn unknown0(self: @This()) bool {
    return self.row.bitAt(11, 0);
}

pub fn unknown1(self: @This()) bool {
    return self.row.bitAt(11, 1);
}
