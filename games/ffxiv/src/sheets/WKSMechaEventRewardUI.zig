//! `WKSMechaEventRewardUI`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSMechaEventRewardUI = @This();

pub const sheet_name = "WKSMechaEventRewardUI";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x53dfb18a;
pub const Sheet = excel.Typed(WKSMechaEventRewardUI);

row: excel.Row,

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unknown2(self: @This()) bool {
    return self.row.bitAt(8, 0);
}

pub fn unknown3(self: @This()) bool {
    return self.row.bitAt(8, 1);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(8, 2);
}
