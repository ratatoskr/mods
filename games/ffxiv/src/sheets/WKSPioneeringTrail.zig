//! `WKSPioneeringTrail`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSPioneeringTrail = @This();

pub const sheet_name = "WKSPioneeringTrail";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x1c29e5ea;
pub const Sheet = excel.Typed(WKSPioneeringTrail);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "ActivationStage", "Thumbnail", "Unknown2", "LogEntry" };

/// The image used as thumbnail for log entry in the Infrastructure Index.
/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn thumbnail(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// The stage at which the log entry is added to the Infrastructure Index.
/// Links to `WKSDevGrade`.
pub fn activationStage(self: @This()) excel.Link(sheets.WKSDevGrade) {
    return .of(self.row.at(u16, 4));
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 6);
}

/// Links to `WKSPioneeringTrailString`.
pub fn logEntry(self: @This()) excel.Link(sheets.WKSPioneeringTrailString) {
    return .of(self.row.at(u16, 8));
}
