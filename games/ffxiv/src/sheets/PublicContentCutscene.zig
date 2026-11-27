//! `PublicContentCutscene`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Cutscene`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PublicContentCutscene = @This();

pub const sheet_name = "PublicContentCutscene";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5d58cc84;
pub const Sheet = excel.Typed(PublicContentCutscene);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Cutscene", "Cutscene2" };

/// Links to `Cutscene`.
pub fn cutscene(self: @This()) excel.Link(sheets.Cutscene) {
    return .of(self.row.at(u32, 0));
}

/// Links to `Cutscene`.
pub fn cutscene2(self: @This()) excel.Link(sheets.Cutscene) {
    return .of(self.row.at(u32, 4));
}
