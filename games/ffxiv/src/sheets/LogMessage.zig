//! `LogMessage`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Text`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const LogMessage = @This();

pub const sheet_name = "LogMessage";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x8a9fe863;
pub const Sheet = excel.Typed(LogMessage);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "LogKind", "DisplayFlags", "Unknown1", "Duration", "Unknown2", "Text" };

pub fn text(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `LogKind`.
pub fn logKind(self: @This()) excel.Link(sheets.LogKind) {
    return .of(self.row.at(u16, 4));
}

/// 1 << 0 (0x1) = Print in Chat
/// 1 << 2 (0x4) = WideText (layer 5, top)
/// 1 << 3 (0x8) = ErrorText (not forced)
/// 1 << 4 (0x10) = Text (no icons, no sounds)
/// 1 << 5 (0x20) = WideText (layer 5, bottom, short)
/// 1 << 6 (0x40) = WideText (layer 5, bottom, long)
/// 1 << 7 (0x80) = PoisonText (layer 10)
/// 1 << 8 (0x100) = ErrorText (forced)
/// 1 << 9 (0x200) = WideText (layer 10, bottom, short)
/// 1 << 10 (0x0400) = WideText (layer 10, bottom, long)
/// 1 << 11 (0x0800) = GimmickHint (Info)
/// 1 << 12 (0x1000) = GimmickHint (Warning)
pub fn displayFlags(self: @This()) u16 {
    return self.row.at(u16, 6);
}

/// Enables a SceneFlags check to remove certain DisplayFlags (0xF883).
pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 8);
}

/// Used for GimmickHint messages.
pub fn duration(self: @This()) u8 {
    return self.row.at(u8, 9);
}

/// Uses the local players ScreenLogManager to print the message in chat, but only if the local player is the source. Unsure why.
pub fn unknown2(self: @This()) bool {
    return self.row.bitAt(10, 0);
}
