//! `PartyContentCutscene`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Cutscene`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PartyContentCutscene = @This();

pub const sheet_name = "PartyContentCutscene";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5d58cc84;
pub const Sheet = excel.Typed(PartyContentCutscene);

row: excel.Row,

/// Links to `Cutscene`.
pub fn cutscene(self: @This()) excel.Link(sheets.Cutscene) {
    return .of(self.row.at(u32, 0));
}

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 4);
}
