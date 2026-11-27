//! `GilShop`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GilShop = @This();

pub const sheet_name = "GilShop";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf50b55e5;
pub const Sheet = excel.Typed(GilShop);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "Icon", "Quest", "AcceptTalk", "FailTalk", "Unknown2", "FestivalId", "FestivalPhase" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// Links to `Quest`.
pub fn quest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 8));
}

/// Links to `DefaultTalk`.
pub fn acceptTalk(self: @This()) excel.Link(sheets.DefaultTalk) {
    return .of(self.row.at(i32, 12));
}

/// Links to `DefaultTalk`.
pub fn failTalk(self: @This()) excel.Link(sheets.DefaultTalk) {
    return .of(self.row.at(i32, 16));
}

pub fn festivalId(self: @This()) u16 {
    return self.row.at(u16, 20);
}

pub fn festivalPhase(self: @This()) u16 {
    return self.row.at(u16, 22);
}

pub fn unknown2(self: @This()) bool {
    return self.row.bitAt(24, 0);
}
