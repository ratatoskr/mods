//! `SecretRecipeBookGroup`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SecretRecipeBookGroup = @This();

pub const sheet_name = "SecretRecipeBookGroup";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xa708a4a0;
pub const Sheet = excel.Typed(SecretRecipeBookGroup);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "SecretRecipeBook[0]", "SecretRecipeBook[1]", "SecretRecipeBook[2]", "SecretRecipeBook[3]", "SecretRecipeBook[4]", "SecretRecipeBook[5]", "SecretRecipeBook[6]", "SecretRecipeBook[7]" };

pub const secret_recipe_book_len = 8;
/// Index is CraftType, also used as bit index in PlayerState.UnlockedSecretRecipeBooks
/// Links to `SecretRecipeBook`.
pub fn secretRecipeBook(self: @This(), n0: usize) excel.Link(sheets.SecretRecipeBook) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

const offsets_1 = [8]u16{ 0, 2, 4, 6, 8, 10, 12, 14 };
