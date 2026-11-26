//! `QuestDefineClient`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Text`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const QuestDefineClient = @This();

pub const sheet_name = "QuestDefineClient";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x98fff20a;
pub const Sheet = excel.Typed(QuestDefineClient);

row: excel.Row,

pub fn text(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `Item`, `Quest`, `ENpcBase`, `EObjName` or `Level`, whichever has the row.
pub fn defineVaue(self: @This()) u32 {
    return self.row.at(u32, 4);
}
