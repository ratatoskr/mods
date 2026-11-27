//! `HWDAnnounce`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HWDAnnounce = @This();

pub const sheet_name = "HWDAnnounce";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x1d91a784;
pub const Sheet = excel.Typed(HWDAnnounce);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "ENPC", "Unknown0", "Unknown1" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `ENpcResident`.
pub fn enpc(self: @This()) excel.Link(sheets.ENpcResident) {
    return .of(self.row.at(u32, 4));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 9);
}
