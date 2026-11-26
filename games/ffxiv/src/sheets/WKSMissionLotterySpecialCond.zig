//! `WKSMissionLotterySpecialCond`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSMissionLotterySpecialCond = @This();

pub const sheet_name = "WKSMissionLotterySpecialCond";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x43bdd5b1;
pub const Sheet = excel.Typed(WKSMissionLotterySpecialCond);

row: excel.Row,

/// Links to `Weather`.
pub fn weatherRequired(self: @This()) excel.Link(sheets.Weather) {
    return .of(self.row.at(u16, 0));
}

pub fn startTimeHour(self: @This()) u8 {
    return self.row.at(u8, 2);
}

pub fn endTimeHour(self: @This()) u8 {
    return self.row.at(u8, 3);
}
