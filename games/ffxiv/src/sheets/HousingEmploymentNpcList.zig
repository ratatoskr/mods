//! `HousingEmploymentNpcList`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Race`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HousingEmploymentNpcList = @This();

pub const sheet_name = "HousingEmploymentNpcList";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x6195119b;
pub const Sheet = excel.Typed(HousingEmploymentNpcList);

row: excel.Row,

/// Links to `ENpcBase`.
pub fn maleENpcBase(self: @This()) excel.Link(sheets.ENpcBase) {
    return .of(self.row.at(u32, 0));
}

/// Links to `ENpcBase`.
pub fn femaleENpcBase(self: @This()) excel.Link(sheets.ENpcBase) {
    return .of(self.row.at(u32, 4));
}

/// Links to `HousingEmploymentNpcRace`.
pub fn race(self: @This()) excel.Link(sheets.HousingEmploymentNpcRace) {
    return .of(self.row.at(u8, 8));
}
