//! `EObj`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EObj = @This();

pub const sheet_name = "EObj";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x30114471;
pub const Sheet = excel.Typed(EObj);

row: excel.Row,

/// Links to `Quest`, `CustomTalk` or `Warp`, whichever has the row.
pub fn data(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// Links to `ExportedSG`.
pub fn sgbPath(self: @This()) excel.Link(sheets.ExportedSG) {
    return .of(self.row.at(u16, 4));
}

pub fn popType(self: @This()) u8 {
    return self.row.at(u8, 6);
}

pub fn invisibility(self: @This()) u8 {
    return self.row.at(u8, 7);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 8);
}

/// Used in EventFramework.CheckInteractRangeEx.
pub fn additionalInteractRangeX(self: @This()) i8 {
    return self.row.at(i8, 9);
}

/// Used in EventFramework.CheckInteractRangeEx.
pub fn additionalInteractRangeY(self: @This()) i8 {
    return self.row.at(i8, 10);
}

pub fn unknown1(self: @This()) bool {
    return self.row.at(u8, 11) != 0;
}

pub fn unknown2(self: @This()) bool {
    return self.row.at(u8, 12) != 0;
}

pub fn unknown3(self: @This()) bool {
    return self.row.at(u8, 13) != 0;
}

pub fn unknown4(self: @This()) bool {
    return self.row.at(u8, 14) != 0;
}

pub fn unknown5(self: @This()) bool {
    return self.row.at(u8, 15) != 0;
}

pub fn unknown6(self: @This()) bool {
    return self.row.at(u8, 16) != 0;
}

pub fn unknown7(self: @This()) bool {
    return self.row.at(u8, 17) != 0;
}

pub fn unknown8(self: @This()) bool {
    return self.row.at(u8, 18) != 0;
}

pub fn targetable(self: @This()) bool {
    return self.row.bitAt(19, 0);
}

pub fn unknown9(self: @This()) bool {
    return self.row.bitAt(19, 1);
}

pub fn unknown10(self: @This()) bool {
    return self.row.bitAt(19, 2);
}

pub fn unknown11(self: @This()) bool {
    return self.row.bitAt(19, 3);
}

/// If set, EObjs managed by a QuestEventHandler calls into Lua first to set up initial shared group timeline state. This can be used by Quest scripting to animate an SGB during a specific sequence of the quest.
pub fn luaSetup(self: @This()) bool {
    return self.row.bitAt(19, 4);
}

/// Not sure what the true meaning of this field means, but its checked within EventObject.UpdateSharedTimelineState.
pub fn sharedTimelineStateUnknown(self: @This()) bool {
    return self.row.bitAt(19, 5);
}
