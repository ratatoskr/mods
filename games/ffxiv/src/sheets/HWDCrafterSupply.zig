//! `HWDCrafterSupply`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HWDCrafterSupply = @This();

pub const sheet_name = "HWDCrafterSupply";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xa04b4cc9;
pub const Sheet = excel.Typed(HWDCrafterSupply);

row: excel.Row,

pub const hwd_crafter_supply_params_len = 23;
pub fn hwdCrafterSupplyParams(self: @This(), n0: usize) HWDCrafterSupplyParamsEntry {
    std.debug.assert(n0 < 23);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const HWDCrafterSupplyParamsEntry = struct {
    row: excel.Row,
    at: [1]u16,

    /// Links to `Item`.
    pub fn itemTradeIn(self: @This()) excel.Link(sheets.Item) {
        return .of(self.row.at(u32, offsets_1[self.at[0]]));
    }

    pub fn baseCollectableRating(self: @This()) u16 {
        return self.row.at(u16, offsets_2[self.at[0]]);
    }

    pub fn midCollectableRating(self: @This()) u16 {
        return self.row.at(u16, offsets_3[self.at[0]]);
    }

    pub fn highCollectableRating(self: @This()) u16 {
        return self.row.at(u16, offsets_4[self.at[0]]);
    }

    /// Links to `HWDCrafterSupplyReward`.
    pub fn baseCollectableReward(self: @This()) excel.Link(sheets.HWDCrafterSupplyReward) {
        return .of(self.row.at(u16, offsets_5[self.at[0]]));
    }

    /// Links to `HWDCrafterSupplyReward`.
    pub fn midCollectableReward(self: @This()) excel.Link(sheets.HWDCrafterSupplyReward) {
        return .of(self.row.at(u16, offsets_6[self.at[0]]));
    }

    /// Links to `HWDCrafterSupplyReward`.
    pub fn highCollectableReward(self: @This()) excel.Link(sheets.HWDCrafterSupplyReward) {
        return .of(self.row.at(u16, offsets_7[self.at[0]]));
    }

    /// Links to `HWDCrafterSupplyReward`.
    pub fn baseCollectableRewardPostPhase(self: @This()) excel.Link(sheets.HWDCrafterSupplyReward) {
        return .of(self.row.at(u16, offsets_8[self.at[0]]));
    }

    /// Links to `HWDCrafterSupplyReward`.
    pub fn midCollectableRewardPostPhase(self: @This()) excel.Link(sheets.HWDCrafterSupplyReward) {
        return .of(self.row.at(u16, offsets_9[self.at[0]]));
    }

    /// Links to `HWDCrafterSupplyReward`.
    pub fn highCollectableRewardPostPhase(self: @This()) excel.Link(sheets.HWDCrafterSupplyReward) {
        return .of(self.row.at(u16, offsets_10[self.at[0]]));
    }

    pub fn level(self: @This()) u8 {
        return self.row.at(u8, offsets_11[self.at[0]]);
    }

    pub fn levelMax(self: @This()) u8 {
        return self.row.at(u8, offsets_12[self.at[0]]);
    }

    pub fn unknown0(self: @This()) u8 {
        return self.row.at(u8, offsets_13[self.at[0]]);
    }

    /// Links to `HWDCrafterSupplyTerm`.
    pub fn termName(self: @This()) excel.Link(sheets.HWDCrafterSupplyTerm) {
        return .of(self.row.at(u8, offsets_14[self.at[0]]));
    }
};

const offsets_1 = [23]u16{ 0, 28, 56, 84, 112, 140, 168, 196, 224, 252, 280, 308, 336, 364, 392, 420, 448, 476, 504, 532, 560, 588, 616 };
const offsets_2 = [23]u16{ 4, 32, 60, 88, 116, 144, 172, 200, 228, 256, 284, 312, 340, 368, 396, 424, 452, 480, 508, 536, 564, 592, 620 };
const offsets_3 = [23]u16{ 6, 34, 62, 90, 118, 146, 174, 202, 230, 258, 286, 314, 342, 370, 398, 426, 454, 482, 510, 538, 566, 594, 622 };
const offsets_4 = [23]u16{ 8, 36, 64, 92, 120, 148, 176, 204, 232, 260, 288, 316, 344, 372, 400, 428, 456, 484, 512, 540, 568, 596, 624 };
const offsets_5 = [23]u16{ 10, 38, 66, 94, 122, 150, 178, 206, 234, 262, 290, 318, 346, 374, 402, 430, 458, 486, 514, 542, 570, 598, 626 };
const offsets_6 = [23]u16{ 12, 40, 68, 96, 124, 152, 180, 208, 236, 264, 292, 320, 348, 376, 404, 432, 460, 488, 516, 544, 572, 600, 628 };
const offsets_7 = [23]u16{ 14, 42, 70, 98, 126, 154, 182, 210, 238, 266, 294, 322, 350, 378, 406, 434, 462, 490, 518, 546, 574, 602, 630 };
const offsets_8 = [23]u16{ 16, 44, 72, 100, 128, 156, 184, 212, 240, 268, 296, 324, 352, 380, 408, 436, 464, 492, 520, 548, 576, 604, 632 };
const offsets_9 = [23]u16{ 18, 46, 74, 102, 130, 158, 186, 214, 242, 270, 298, 326, 354, 382, 410, 438, 466, 494, 522, 550, 578, 606, 634 };
const offsets_10 = [23]u16{ 20, 48, 76, 104, 132, 160, 188, 216, 244, 272, 300, 328, 356, 384, 412, 440, 468, 496, 524, 552, 580, 608, 636 };
const offsets_11 = [23]u16{ 22, 50, 78, 106, 134, 162, 190, 218, 246, 274, 302, 330, 358, 386, 414, 442, 470, 498, 526, 554, 582, 610, 638 };
const offsets_12 = [23]u16{ 23, 51, 79, 107, 135, 163, 191, 219, 247, 275, 303, 331, 359, 387, 415, 443, 471, 499, 527, 555, 583, 611, 639 };
const offsets_13 = [23]u16{ 24, 52, 80, 108, 136, 164, 192, 220, 248, 276, 304, 332, 360, 388, 416, 444, 472, 500, 528, 556, 584, 612, 640 };
const offsets_14 = [23]u16{ 25, 53, 81, 109, 137, 165, 193, 221, 249, 277, 305, 333, 361, 389, 417, 445, 473, 501, 529, 557, 585, 613, 641 };
