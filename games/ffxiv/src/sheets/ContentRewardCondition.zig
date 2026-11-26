//! `ContentRewardCondition`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ContentRewardCondition = @This();

pub const sheet_name = "ContentRewardCondition";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdcfd9eba;
pub const Sheet = excel.Typed(ContentRewardCondition);

row: excel.Row,

/// 0 = Always rewarded
/// 1 = Character has reached current expansions max level
/// 2 = Character has reached at least 50
/// 3 = Character has reached at least 60
/// 4 = Character has reached at least 70
/// 5 = Character has reached at least 80
/// 6 = Character has reached at least 90
pub fn maxLevelCondition(self: @This()) u8 {
    return self.row.at(u8, 0);
}
