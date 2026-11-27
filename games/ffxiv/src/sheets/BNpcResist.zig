//! `BNpcResist`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BNpcResist = @This();

pub const sheet_name = "BNpcResist";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xfb3c87a2;
pub const Sheet = excel.Typed(BNpcResist);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "ResistsSlow", "ResistsPetrify", "ResistsParalysis", "ResistsInterrupt", "ResistsBlind", "ResistsPoison", "ResistsStun", "ResistsSleep", "ResistsBind", "ResistsHeavy", "ResistsDeath" };

pub fn resistsSlow(self: @This()) bool {
    return self.row.at(u8, 0) != 0;
}

pub fn resistsPetrify(self: @This()) bool {
    return self.row.at(u8, 1) != 0;
}

pub fn resistsParalysis(self: @This()) bool {
    return self.row.at(u8, 2) != 0;
}

pub fn resistsInterrupt(self: @This()) bool {
    return self.row.at(u8, 3) != 0;
}

pub fn resistsBlind(self: @This()) bool {
    return self.row.at(u8, 4) != 0;
}

pub fn resistsPoison(self: @This()) bool {
    return self.row.at(u8, 5) != 0;
}

pub fn resistsStun(self: @This()) bool {
    return self.row.at(u8, 6) != 0;
}

pub fn resistsSleep(self: @This()) bool {
    return self.row.at(u8, 7) != 0;
}

pub fn resistsBind(self: @This()) bool {
    return self.row.at(u8, 8) != 0;
}

pub fn resistsHeavy(self: @This()) bool {
    return self.row.at(u8, 9) != 0;
}

pub fn resistsDeath(self: @This()) bool {
    return self.row.at(u8, 10) != 0;
}
