//! `BGMFade`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BGMFade = @This();

pub const sheet_name = "BGMFade";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf09994a9;
pub const Sheet = excel.Typed(BGMFade);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "SceneOut", "SceneIn", "BGMFadeType" };

pub fn sceneOut(self: @This()) i32 {
    return self.row.at(i32, 0);
}

pub fn sceneIn(self: @This()) i32 {
    return self.row.at(i32, 4);
}

/// Links to `BGMFadeType`.
pub fn bgmFadeType(self: @This()) excel.Link(sheets.BGMFadeType) {
    return .of(self.row.at(i32, 8));
}
