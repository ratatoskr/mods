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

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "LotteryExchangeParams[0].ItemAccepted", "LotteryExchangeParams[1].ItemAccepted", "LotteryExchangeParams[2].ItemAccepted", "LotteryExchangeParams[3].ItemAccepted", "LotteryExchangeParams[4].ItemAccepted", "LotteryExchangeParams[5].ItemAccepted", "LotteryExchangeParams[6].ItemAccepted", "LotteryExchangeParams[7].ItemAccepted", "LotteryExchangeParams[8].ItemAccepted", "LotteryExchangeParams[9].ItemAccepted", "LotteryExchangeParams[10].ItemAccepted", "LotteryExchangeParams[11].ItemAccepted", "LotteryExchangeParams[12].ItemAccepted", "LotteryExchangeParams[13].ItemAccepted", "LotteryExchangeParams[14].ItemAccepted", "LotteryExchangeParams[15].ItemAccepted", "LotteryExchangeParams[16].ItemAccepted", "LotteryExchangeParams[17].ItemAccepted", "LotteryExchangeParams[18].ItemAccepted", "LotteryExchangeParams[19].ItemAccepted", "LotteryExchangeParams[20].ItemAccepted", "LotteryExchangeParams[21].ItemAccepted", "LotteryExchangeParams[22].ItemAccepted", "LotteryExchangeParams[23].ItemAccepted", "LotteryExchangeParams[24].ItemAccepted", "LotteryExchangeParams[25].ItemAccepted", "LotteryExchangeParams[26].ItemAccepted", "LotteryExchangeParams[27].ItemAccepted", "LotteryExchangeParams[28].ItemAccepted", "LotteryExchangeParams[29].ItemAccepted", "LotteryExchangeParams[30].ItemAccepted", "LotteryExchangeParams[31].ItemAccepted", "LotteryExchangeParams[0].AmountAccepted", "LotteryExchangeParams[1].AmountAccepted", "LotteryExchangeParams[2].AmountAccepted", "LotteryExchangeParams[3].AmountAccepted", "LotteryExchangeParams[4].AmountAccepted", "LotteryExchangeParams[5].AmountAccepted", "LotteryExchangeParams[6].AmountAccepted", "LotteryExchangeParams[7].AmountAccepted", "LotteryExchangeParams[8].AmountAccepted", "LotteryExchangeParams[9].AmountAccepted", "LotteryExchangeParams[10].AmountAccepted", "LotteryExchangeParams[11].AmountAccepted", "LotteryExchangeParams[12].AmountAccepted", "LotteryExchangeParams[13].AmountAccepted", "LotteryExchangeParams[14].AmountAccepted", "LotteryExchangeParams[15].AmountAccepted", "LotteryExchangeParams[16].AmountAccepted", "LotteryExchangeParams[17].AmountAccepted", "LotteryExchangeParams[18].AmountAccepted", "LotteryExchangeParams[19].AmountAccepted", "LotteryExchangeParams[20].AmountAccepted", "LotteryExchangeParams[21].AmountAccepted", "LotteryExchangeParams[22].AmountAccepted", "LotteryExchangeParams[23].AmountAccepted", "LotteryExchangeParams[24].AmountAccepted", "LotteryExchangeParams[25].AmountAccepted", "LotteryExchangeParams[26].AmountAccepted", "LotteryExchangeParams[27].AmountAccepted", "LotteryExchangeParams[28].AmountAccepted", "LotteryExchangeParams[29].AmountAccepted", "LotteryExchangeParams[30].AmountAccepted", "LotteryExchangeParams[31].AmountAccepted", "LotteryExchangeParams[0].Unknown0", "LotteryExchangeParams[1].Unknown0", "LotteryExchangeParams[2].Unknown0", "LotteryExchangeParams[3].Unknown0", "LotteryExchangeParams[4].Unknown0", "LotteryExchangeParams[5].Unknown0", "LotteryExchangeParams[6].Unknown0", "LotteryExchangeParams[7].Unknown0", "LotteryExchangeParams[8].Unknown0", "LotteryExchangeParams[9].Unknown0", "LotteryExchangeParams[10].Unknown0", "LotteryExchangeParams[11].Unknown0", "LotteryExchangeParams[12].Unknown0", "LotteryExchangeParams[13].Unknown0", "LotteryExchangeParams[14].Unknown0", "LotteryExchangeParams[15].Unknown0", "LotteryExchangeParams[16].Unknown0", "LotteryExchangeParams[17].Unknown0", "LotteryExchangeParams[18].Unknown0", "LotteryExchangeParams[19].Unknown0", "LotteryExchangeParams[20].Unknown0", "LotteryExchangeParams[21].Unknown0", "LotteryExchangeParams[22].Unknown0", "LotteryExchangeParams[23].Unknown0", "LotteryExchangeParams[24].Unknown0", "LotteryExchangeParams[25].Unknown0", "LotteryExchangeParams[26].Unknown0", "LotteryExchangeParams[27].Unknown0", "LotteryExchangeParams[28].Unknown0", "LotteryExchangeParams[29].Unknown0", "LotteryExchangeParams[30].Unknown0", "LotteryExchangeParams[31].Unknown0", "LotteryExchangeParams[0].Unknown1", "LotteryExchangeParams[1].Unknown1", "LotteryExchangeParams[2].Unknown1", "LotteryExchangeParams[3].Unknown1", "LotteryExchangeParams[4].Unknown1", "LotteryExchangeParams[5].Unknown1", "LotteryExchangeParams[6].Unknown1", "LotteryExchangeParams[7].Unknown1", "LotteryExchangeParams[8].Unknown1", "LotteryExchangeParams[9].Unknown1", "LotteryExchangeParams[10].Unknown1", "LotteryExchangeParams[11].Unknown1", "LotteryExchangeParams[12].Unknown1", "LotteryExchangeParams[13].Unknown1", "LotteryExchangeParams[14].Unknown1", "LotteryExchangeParams[15].Unknown1", "LotteryExchangeParams[16].Unknown1", "LotteryExchangeParams[17].Unknown1", "LotteryExchangeParams[18].Unknown1", "LotteryExchangeParams[19].Unknown1", "LotteryExchangeParams[20].Unknown1", "LotteryExchangeParams[21].Unknown1", "LotteryExchangeParams[22].Unknown1", "LotteryExchangeParams[23].Unknown1", "LotteryExchangeParams[24].Unknown1", "LotteryExchangeParams[25].Unknown1", "LotteryExchangeParams[26].Unknown1", "LotteryExchangeParams[27].Unknown1", "LotteryExchangeParams[28].Unknown1", "LotteryExchangeParams[29].Unknown1", "LotteryExchangeParams[30].Unknown1", "LotteryExchangeParams[31].Unknown1", "Script", "LogMessage[0]", "LogMessage[1]", "LogMessage[2]", "Unknown0" };

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
