//! `InstanceContentType`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const InstanceContentType = @This();

pub const sheet_name = "InstanceContentType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf9304387;
pub const Sheet = excel.Typed(InstanceContentType);

row: excel.Row,

/// Links to `LogMessage`.
pub fn startLogMessage(self: @This()) excel.Link(sheets.LogMessage) {
    return .of(self.row.at(u32, 0));
}

/// Used for certain duties. If not 0, then the client reads from a special unlock/completed array in PlayerState.
pub fn lookupIndex(self: @This()) u8 {
    return self.row.at(u8, 4);
}

/// If false, the duty always reports itself as not completed. If LookupIndex != 0, that is used still.
pub fn isCompletable(self: @This()) bool {
    return self.row.bitAt(5, 0);
}

pub fn unknown3(self: @This()) bool {
    return self.row.bitAt(5, 1);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(5, 2);
}

pub fn unknown5(self: @This()) bool {
    return self.row.bitAt(5, 3);
}

pub fn unknown6(self: @This()) bool {
    return self.row.bitAt(5, 4);
}

pub fn supportsPartyMemberPortraits(self: @This()) bool {
    return self.row.bitAt(5, 5);
}

pub fn unknown8(self: @This()) bool {
    return self.row.bitAt(5, 6);
}
