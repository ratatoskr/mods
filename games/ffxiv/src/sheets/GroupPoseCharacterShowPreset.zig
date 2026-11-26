//! `GroupPoseCharacterShowPreset`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GroupPoseCharacterShowPreset = @This();

pub const sheet_name = "GroupPoseCharacterShowPreset";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe9f11aa8;
pub const Sheet = excel.Typed(GroupPoseCharacterShowPreset);

row: excel.Row,

pub fn unknown0(self: @This()) bool {
    return self.row.bitAt(0, 0);
}

pub fn unknown1(self: @This()) bool {
    return self.row.bitAt(0, 1);
}

pub fn unknown2(self: @This()) bool {
    return self.row.bitAt(0, 2);
}

pub fn unknown3(self: @This()) bool {
    return self.row.bitAt(0, 3);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(0, 4);
}

pub fn unknown5(self: @This()) bool {
    return self.row.bitAt(0, 5);
}

pub fn unknown6(self: @This()) bool {
    return self.row.bitAt(0, 6);
}

pub fn unknown7(self: @This()) bool {
    return self.row.bitAt(0, 7);
}

pub fn unknown8(self: @This()) bool {
    return self.row.bitAt(1, 0);
}

pub fn unknown9(self: @This()) bool {
    return self.row.bitAt(1, 1);
}

pub fn unknown10(self: @This()) bool {
    return self.row.bitAt(1, 2);
}

pub fn unknown11(self: @This()) bool {
    return self.row.bitAt(1, 3);
}

pub fn unknown12(self: @This()) bool {
    return self.row.bitAt(1, 4);
}

pub fn unknown13(self: @This()) bool {
    return self.row.bitAt(1, 5);
}
