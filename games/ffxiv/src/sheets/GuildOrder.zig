//! `GuildOrder`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GuildOrder = @This();

pub const sheet_name = "GuildOrder";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xbdf9fa30;
pub const Sheet = excel.Typed(GuildOrder);

row: excel.Row,

pub fn objective(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description1(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn description2(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn description3(self: @This()) []const u8 {
    return self.row.stringAt(12);
}

pub fn completionBonusExp(self: @This()) u32 {
    return self.row.at(u32, 16);
}

pub fn rewardExp(self: @This()) u32 {
    return self.row.at(u32, 20);
}

pub fn completionBonusGil(self: @This()) u32 {
    return self.row.at(u32, 24);
}

pub fn rewardGil(self: @This()) u32 {
    return self.row.at(u32, 28);
}

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 32);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 36);
}

pub fn unknown2(self: @This()) u32 {
    return self.row.at(u32, 40);
}

pub fn unknown3(self: @This()) u32 {
    return self.row.at(u32, 44);
}

pub fn unknown4(self: @This()) u16 {
    return self.row.at(u16, 48);
}

pub fn unknown5(self: @This()) u16 {
    return self.row.at(u16, 50);
}

pub fn unknown6(self: @This()) bool {
    return self.row.at(u8, 52) != 0;
}

pub fn unknown7(self: @This()) bool {
    return self.row.at(u8, 53) != 0;
}

/// Links to `ENpcResident`.
pub fn eNpcName(self: @This()) excel.Link(sheets.ENpcResident) {
    return .of(self.row.at(u32, 56));
}
