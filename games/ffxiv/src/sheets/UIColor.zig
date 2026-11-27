//! `UIColor`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Dark`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const UIColor = @This();

pub const sheet_name = "UIColor";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x182f49e3;
pub const Sheet = excel.Typed(UIColor);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Dark", "Light", "ClassicFF", "ClearBlue", "ClearWhite", "ClearGreen", "ClearGrey", "ClearPink" };

/// An RGB color, 0xRRGGBB.
pub fn dark(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// An RGB color, 0xRRGGBB.
pub fn light(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// An RGB color, 0xRRGGBB.
pub fn classicFF(self: @This()) u32 {
    return self.row.at(u32, 8);
}

/// An RGB color, 0xRRGGBB.
pub fn clearBlue(self: @This()) u32 {
    return self.row.at(u32, 12);
}

/// An RGB color, 0xRRGGBB.
pub fn clearWhite(self: @This()) u32 {
    return self.row.at(u32, 16);
}

/// An RGB color, 0xRRGGBB.
pub fn clearGreen(self: @This()) u32 {
    return self.row.at(u32, 20);
}

/// An RGB color, 0xRRGGBB.
pub fn clearGrey(self: @This()) u32 {
    return self.row.at(u32, 24);
}

/// An RGB color, 0xRRGGBB.
pub fn clearPink(self: @This()) u32 {
    return self.row.at(u32, 28);
}
