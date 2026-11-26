//! `HousingMerchantPose`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Pose`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HousingMerchantPose = @This();

pub const sheet_name = "HousingMerchantPose";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x3d65a9f1;
pub const Sheet = excel.Typed(HousingMerchantPose);

row: excel.Row,

pub fn pose(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `ActionTimeline`.
pub fn actionTimeline(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 4));
}
