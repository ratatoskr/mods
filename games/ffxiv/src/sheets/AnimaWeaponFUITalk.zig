//! `AnimaWeaponFUITalk`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Dialogue`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AnimaWeaponFUITalk = @This();

pub const sheet_name = "AnimaWeaponFUITalk";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xda365c51;
pub const Sheet = excel.Typed(AnimaWeaponFUITalk);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{"Dialogue"};

/// Links to `AnimaWeaponFUITalkParam`.
pub fn dialogue(self: @This()) excel.Link(sheets.AnimaWeaponFUITalkParam) {
    return .of(self.row.at(i32, 0));
}
