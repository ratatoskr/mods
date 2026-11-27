//! `PreHandler`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Target`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PreHandler = @This();

pub const sheet_name = "PreHandler";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xb3b4ab94;
pub const Sheet = excel.Typed(PreHandler);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Image", "Target", "UnlockQuest", "AcceptMessage", "DenyMessage", "Unknown1", "Unknown2" };

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn image(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// Links to `CollectablesShop`, `InclusionShop`, `GilShop`, `SpecialShop` or `Description`, whichever has the row.
pub fn target(self: @This()) u32 {
    return self.row.at(u32, 8);
}

/// Links to `Quest`.
pub fn unlockQuest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 12));
}

/// Links to `DefaultTalk`.
pub fn acceptMessage(self: @This()) excel.Link(sheets.DefaultTalk) {
    return .of(self.row.at(u32, 16));
}

/// Links to `DefaultTalk`.
pub fn denyMessage(self: @This()) excel.Link(sheets.DefaultTalk) {
    return .of(self.row.at(u32, 20));
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 24);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 25);
}
