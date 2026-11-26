//! `LotteryExchangeShop`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const LotteryExchangeShop = @This();

pub const sheet_name = "LotteryExchangeShop";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xfd7b4ce5;
pub const Sheet = excel.Typed(LotteryExchangeShop);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub const lottery_exchange_params_len = 32;
pub fn lotteryExchangeParams(self: @This(), n0: usize) LotteryExchangeParamsEntry {
    std.debug.assert(n0 < 32);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const LotteryExchangeParamsEntry = struct {
    row: excel.Row,
    at: [1]u16,

    pub fn amountAccepted(self: @This()) u32 {
        return self.row.at(u32, offsets_1[self.at[0]]);
    }

    /// Links to `Item`.
    pub fn itemAccepted(self: @This()) excel.Link(sheets.Item) {
        return .of(self.row.at(i32, offsets_2[self.at[0]]));
    }

    pub fn unknown0(self: @This()) u8 {
        return self.row.at(u8, offsets_3[self.at[0]]);
    }

    pub fn unknown1(self: @This()) u8 {
        return self.row.at(u8, offsets_4[self.at[0]]);
    }
};

pub fn script(self: @This()) []const u8 {
    return self.row.stringAt(388);
}

pub const log_message_len = 3;
/// Links to `LogMessage`.
pub fn logMessage(self: @This(), n0: usize) excel.Link(sheets.LogMessage) {
    return .of(self.row.at(u32, offsets_5[n0]));
}

pub fn unknown0(self: @This()) bool {
    return self.row.bitAt(404, 0);
}

const offsets_1 = [32]u16{ 4, 16, 28, 40, 52, 64, 76, 88, 100, 112, 124, 136, 148, 160, 172, 184, 196, 208, 220, 232, 244, 256, 268, 280, 292, 304, 316, 328, 340, 352, 364, 376 };
const offsets_2 = [32]u16{ 8, 20, 32, 44, 56, 68, 80, 92, 104, 116, 128, 140, 152, 164, 176, 188, 200, 212, 224, 236, 248, 260, 272, 284, 296, 308, 320, 332, 344, 356, 368, 380 };
const offsets_3 = [32]u16{ 12, 24, 36, 48, 60, 72, 84, 96, 108, 120, 132, 144, 156, 168, 180, 192, 204, 216, 228, 240, 252, 264, 276, 288, 300, 312, 324, 336, 348, 360, 372, 384 };
const offsets_4 = [32]u16{ 13, 25, 37, 49, 61, 73, 85, 97, 109, 121, 133, 145, 157, 169, 181, 193, 205, 217, 229, 241, 253, 265, 277, 289, 301, 313, 325, 337, 349, 361, 373, 385 };
const offsets_5 = [3]u16{ 392, 396, 400 };
