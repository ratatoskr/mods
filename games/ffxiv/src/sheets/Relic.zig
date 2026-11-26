//! `Relic`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `ItemAnimus`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Relic = @This();

pub const sheet_name = "Relic";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x8080ef57;
pub const Sheet = excel.Typed(Relic);

row: excel.Row,

/// Links to `Item`.
pub fn itemAtma(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 0));
}

/// Links to `Item`.
pub fn itemAnimus(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 4));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 8);
}

/// Links to `Materia`.
pub fn materia0(self: @This()) excel.Link(sheets.Materia) {
    return .of(self.row.at(u16, 12));
}

/// Links to `Materia`.
pub fn materia1(self: @This()) excel.Link(sheets.Materia) {
    return .of(self.row.at(u16, 14));
}

/// Links to `Materia`.
pub fn materia2(self: @This()) excel.Link(sheets.Materia) {
    return .of(self.row.at(u16, 16));
}

/// Links to `Materia`.
pub fn materia3(self: @This()) excel.Link(sheets.Materia) {
    return .of(self.row.at(u16, 18));
}

/// Links to `RelicNote`.
pub fn noteMain0(self: @This()) excel.Link(sheets.RelicNote) {
    return .of(self.row.at(u8, 20));
}

/// Links to `RelicNote`.
pub fn noteSub0(self: @This()) excel.Link(sheets.RelicNote) {
    return .of(self.row.at(u8, 21));
}

/// Links to `RelicNote`.
pub fn noteSelection10(self: @This()) excel.Link(sheets.RelicNote) {
    return .of(self.row.at(u8, 22));
}

/// Links to `RelicNote`.
pub fn noteMain1(self: @This()) excel.Link(sheets.RelicNote) {
    return .of(self.row.at(u8, 23));
}

/// Links to `RelicNote`.
pub fn noteSub1(self: @This()) excel.Link(sheets.RelicNote) {
    return .of(self.row.at(u8, 24));
}

/// Links to `RelicNote`.
pub fn noteSelection1(self: @This()) excel.Link(sheets.RelicNote) {
    return .of(self.row.at(u8, 25));
}

/// Links to `RelicNote`.
pub fn noteMain2(self: @This()) excel.Link(sheets.RelicNote) {
    return .of(self.row.at(u8, 26));
}

/// Links to `RelicNote`.
pub fn noteSub2(self: @This()) excel.Link(sheets.RelicNote) {
    return .of(self.row.at(u8, 27));
}

/// Links to `RelicNote`.
pub fn noteSelection3(self: @This()) excel.Link(sheets.RelicNote) {
    return .of(self.row.at(u8, 28));
}
