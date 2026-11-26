//! `Quest`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Quest = @This();

pub const sheet_name = "Quest";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x0ab3fe19;
pub const Sheet = excel.Typed(Quest);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub const quest_params_len = 50;
pub fn questParams(self: @This(), n0: usize) QuestParamsEntry {
    std.debug.assert(n0 < 50);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const QuestParamsEntry = struct {
    row: excel.Row,
    at: [1]u16,

    pub fn scriptInstruction(self: @This()) []const u8 {
        return self.row.stringAt(offsets_1[self.at[0]]);
    }

    pub fn scriptArg(self: @This()) u32 {
        return self.row.at(u32, offsets_2[self.at[0]]);
    }
};

pub const quest_listener_params_len = 64;
pub fn questListenerParams(self: @This(), n0: usize) QuestListenerParamsEntry {
    std.debug.assert(n0 < 64);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const QuestListenerParamsEntry = struct {
    row: excel.Row,
    at: [1]u16,

    pub fn listener(self: @This()) u32 {
        return self.row.at(u32, offsets_3[self.at[0]]);
    }

    pub fn conditionValue(self: @This()) u32 {
        return self.row.at(u32, offsets_4[self.at[0]]);
    }

    pub fn behavior(self: @This()) u16 {
        return self.row.at(u16, offsets_5[self.at[0]]);
    }

    pub fn actorSpawnSeq(self: @This()) u8 {
        return self.row.at(u8, offsets_6[self.at[0]]);
    }

    pub fn actorDespawnSeq(self: @This()) u8 {
        return self.row.at(u8, offsets_7[self.at[0]]);
    }

    pub fn unknown0(self: @This()) u8 {
        return self.row.at(u8, offsets_8[self.at[0]]);
    }

    pub fn unknown1(self: @This()) u8 {
        return self.row.at(u8, offsets_9[self.at[0]]);
    }

    pub fn questUInt8A(self: @This()) u8 {
        return self.row.at(u8, offsets_10[self.at[0]]);
    }

    pub fn conditionType(self: @This()) u8 {
        return self.row.at(u8, offsets_11[self.at[0]]);
    }

    pub fn conditionOperator(self: @This()) u8 {
        return self.row.at(u8, offsets_12[self.at[0]]);
    }

    pub fn visibleBool(self: @This()) bool {
        return self.row.bitAt(@intCast(offsets_13[self.at[0]] >> 3), @intCast(offsets_13[self.at[0]] & 7));
    }

    pub fn conditionBool(self: @This()) bool {
        return self.row.bitAt(@intCast(offsets_14[self.at[0]] >> 3), @intCast(offsets_14[self.at[0]] & 7));
    }

    pub fn itemBool(self: @This()) bool {
        return self.row.bitAt(@intCast(offsets_15[self.at[0]] >> 3), @intCast(offsets_15[self.at[0]] & 7));
    }

    pub fn announceBool(self: @This()) bool {
        return self.row.bitAt(@intCast(offsets_16[self.at[0]] >> 3), @intCast(offsets_16[self.at[0]] & 7));
    }

    pub fn behaviorBool(self: @This()) bool {
        return self.row.bitAt(@intCast(offsets_17[self.at[0]] >> 3), @intCast(offsets_17[self.at[0]] & 7));
    }

    pub fn acceptBool(self: @This()) bool {
        return self.row.bitAt(@intCast(offsets_18[self.at[0]] >> 3), @intCast(offsets_18[self.at[0]] & 7));
    }

    pub fn qualifiedBool(self: @This()) bool {
        return self.row.bitAt(@intCast(offsets_19[self.at[0]] >> 3), @intCast(offsets_19[self.at[0]] & 7));
    }

    pub fn canTargetBool(self: @This()) bool {
        return self.row.bitAt(@intCast(offsets_20[self.at[0]] >> 3), @intCast(offsets_20[self.at[0]] & 7));
    }
};

pub const todo_params_len = 24;
pub fn todoParams(self: @This(), n0: usize) TodoParamsEntry {
    std.debug.assert(n0 < 24);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const TodoParamsEntry = struct {
    row: excel.Row,
    at: [1]u16,

    pub const to_do_location_len = 8;
    /// Links to `Level`.
    pub fn toDoLocation(self: @This(), n1: usize) excel.Link(sheets.Level) {
        return .of(self.row.at(u32, offsets_21[self.at[0]][n1]));
    }

    pub fn toDoCompleteSeq(self: @This()) u8 {
        return self.row.at(u8, offsets_22[self.at[0]]);
    }

    pub fn toDoQty(self: @This()) u8 {
        return self.row.at(u8, offsets_23[self.at[0]]);
    }

    pub fn countableNum(self: @This()) u8 {
        return self.row.at(u8, offsets_24[self.at[0]]);
    }
};

pub fn gilReward(self: @This()) u32 {
    return self.row.at(u32, 2548);
}

/// Links to `Item`.
pub fn currencyReward(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 2552));
}

pub fn currencyRewardCount(self: @This()) u32 {
    return self.row.at(u32, 2556);
}

pub const reward_len = 7;
/// Links by `ItemRewardType`: 1 to `Item`, 3 to `Item`, 5 to `Item`, 6 to `QuestClassJobReward`, 7 to `BeastRankBonus`.
pub fn reward(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_25[n0]);
}

pub const optional_item_reward_len = 5;
/// Links to `Item`.
pub fn optionalItemReward(self: @This(), n0: usize) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, offsets_26[n0]));
}

/// Links to `InstanceContent`.
pub fn instanceContentUnlock(self: @This()) excel.Link(sheets.InstanceContent) {
    return .of(self.row.at(u32, 2608));
}

pub fn expFactor(self: @This()) u16 {
    return self.row.at(u16, 2612);
}

/// Links to `Emote`.
pub fn emoteReward(self: @This()) excel.Link(sheets.Emote) {
    return .of(self.row.at(u16, 2614));
}

/// Links to `Action`.
pub fn actionReward(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(u16, 2616));
}

pub const system_reward_len = 2;
pub fn systemReward(self: @This(), n0: usize) u16 {
    return self.row.at(u16, offsets_27[n0]);
}

pub fn gcTypeReward(self: @This()) u16 {
    return self.row.at(u16, 2622);
}

pub const item_catalyst_len = 3;
/// Links to `Item`.
pub fn itemCatalyst(self: @This(), n0: usize) excel.Link(sheets.Item) {
    return .of(self.row.at(u8, offsets_28[n0]));
}

pub const item_count_catalyst_len = 3;
pub fn itemCountCatalyst(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_29[n0]);
}

pub fn itemRewardType(self: @This()) u8 {
    return self.row.at(u8, 2630);
}

pub const item_count_reward_len = 7;
pub fn itemCountReward(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_30[n0]);
}

pub const reward_stain_len = 7;
/// Links to `Stain`.
pub fn rewardStain(self: @This(), n0: usize) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, offsets_31[n0]));
}

pub const optional_item_count_reward_len = 5;
pub fn optionalItemCountReward(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_32[n0]);
}

pub const optional_item_stain_reward_len = 5;
/// Links to `Stain`.
pub fn optionalItemStainReward(self: @This(), n0: usize) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, offsets_33[n0]));
}

pub const general_action_reward_len = 2;
/// Links to `GeneralAction`.
pub fn generalActionReward(self: @This(), n0: usize) excel.Link(sheets.GeneralAction) {
    return .of(self.row.at(u8, offsets_34[n0]));
}

/// Links to `QuestRewardOther`.
pub fn otherReward(self: @This()) excel.Link(sheets.QuestRewardOther) {
    return .of(self.row.at(u8, 2657));
}

pub fn tomestone(self: @This()) u8 {
    return self.row.at(u8, 2658);
}

pub fn tomestoneReward(self: @This()) u8 {
    return self.row.at(u8, 2659);
}

pub fn tomestoneCountReward(self: @This()) u8 {
    return self.row.at(u8, 2660);
}

pub fn reputationReward(self: @This()) u8 {
    return self.row.at(u8, 2661);
}

pub fn unknown0(self: @This()) bool {
    return self.row.at(u8, 2662) != 0;
}

pub fn unknown1(self: @This()) bool {
    return self.row.at(u8, 2663) != 0;
}

pub fn unknown2(self: @This()) bool {
    return self.row.at(u8, 2664) != 0;
}

pub fn unknown3(self: @This()) bool {
    return self.row.at(u8, 2665) != 0;
}

pub fn unknown4(self: @This()) bool {
    return self.row.at(u8, 2666) != 0;
}

pub fn unknown5(self: @This()) bool {
    return self.row.at(u8, 2667) != 0;
}

pub fn unknown6(self: @This()) bool {
    return self.row.at(u8, 2668) != 0;
}

pub const optional_item_is_hq_reward_len = 5;
pub fn optionalItemIsHQReward(self: @This(), n0: usize) bool {
    return self.row.at(u8, offsets_35[n0]) != 0;
}

pub fn id(self: @This()) []const u8 {
    return self.row.stringAt(2676);
}

pub const previous_quest_len = 3;
/// Links to `Quest`.
pub fn previousQuest(self: @This(), n0: usize) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, offsets_36[n0]));
}

pub const quest_lock_len = 2;
/// Links to `Quest`.
pub fn questLock(self: @This(), n0: usize) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, offsets_37[n0]));
}

pub const instance_content_len = 3;
/// Links to `InstanceContent`.
pub fn instanceContent(self: @This(), n0: usize) excel.Link(sheets.InstanceContent) {
    return .of(self.row.at(u32, offsets_38[n0]));
}

/// Links to `EObjName` or `ENpcResident`, whichever has the row.
pub fn issuerStart(self: @This()) u32 {
    return self.row.at(u32, 2712);
}

/// Links to `Level`.
pub fn issuerLocation(self: @This()) excel.Link(sheets.Level) {
    return .of(self.row.at(u32, 2716));
}

/// Links to `EObjName` or `ENpcResident`, whichever has the row.
pub fn targetEnd(self: @This()) u32 {
    return self.row.at(u32, 2720);
}

/// Links to `JournalGenre`.
pub fn journalGenre(self: @This()) excel.Link(sheets.JournalGenre) {
    return .of(self.row.at(u32, 2724));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 2728);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn iconSpecial(self: @This()) u32 {
    return self.row.at(u32, 2732);
}

/// Links to `Mount`.
pub fn mountRequired(self: @This()) excel.Link(sheets.Mount) {
    return .of(self.row.at(i32, 2736));
}

pub const class_job_level_len = 2;
pub fn classJobLevel(self: @This(), n0: usize) u16 {
    return self.row.at(u16, offsets_39[n0]);
}

pub fn header(self: @This()) u16 {
    return self.row.at(u16, 2744);
}

/// Links to `Festival`.
pub fn festival(self: @This()) excel.Link(sheets.Festival) {
    return .of(self.row.at(u16, 2746));
}

pub fn bellStart(self: @This()) u16 {
    return self.row.at(u16, 2748);
}

pub fn bellEnd(self: @This()) u16 {
    return self.row.at(u16, 2750);
}

pub fn beastReputationValue(self: @This()) u16 {
    return self.row.at(u16, 2752);
}

/// Links to `Behavior`.
pub fn clientBehavior(self: @This()) excel.Link(sheets.Behavior) {
    return .of(self.row.at(u16, 2754));
}

/// Links to `QuestClassJobSupply`.
pub fn questClassJobSupply(self: @This()) excel.Link(sheets.QuestClassJobSupply) {
    return .of(self.row.at(u16, 2756));
}

/// Links to `PlaceName`.
pub fn placeName(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, 2758));
}

pub fn sortKey(self: @This()) u16 {
    return self.row.at(u16, 2760);
}

/// Links to `ExVersion`.
pub fn expansion(self: @This()) excel.Link(sheets.ExVersion) {
    return .of(self.row.at(u8, 2762));
}

/// Links to `ClassJobCategory`.
pub fn classJobCategory0(self: @This()) excel.Link(sheets.ClassJobCategory) {
    return .of(self.row.at(u8, 2763));
}

pub fn questLevelOffset(self: @This()) u8 {
    return self.row.at(u8, 2764);
}

/// Links to `ClassJobCategory`.
pub fn classJobCategory1(self: @This()) excel.Link(sheets.ClassJobCategory) {
    return .of(self.row.at(u8, 2765));
}

pub fn previousQuestJoin(self: @This()) u8 {
    return self.row.at(u8, 2766);
}

pub fn unknown7(self: @This()) u8 {
    return self.row.at(u8, 2767);
}

pub fn questLockJoin(self: @This()) u8 {
    return self.row.at(u8, 2768);
}

pub fn unknown8(self: @This()) u8 {
    return self.row.at(u8, 2769);
}

pub fn unknown9(self: @This()) u8 {
    return self.row.at(u8, 2770);
}

/// Links to `ClassJob`.
pub fn classJobUnlock(self: @This()) excel.Link(sheets.ClassJob) {
    return .of(self.row.at(u8, 2771));
}

/// Links to `GrandCompany`.
pub fn grandCompany(self: @This()) excel.Link(sheets.GrandCompany) {
    return .of(self.row.at(u8, 2772));
}

/// Links to `GrandCompanyRank`.
pub fn grandCompanyRank(self: @This()) excel.Link(sheets.GrandCompanyRank) {
    return .of(self.row.at(u8, 2773));
}

pub fn instanceContentJoin(self: @This()) u8 {
    return self.row.at(u8, 2774);
}

pub fn festivalBegin(self: @This()) u8 {
    return self.row.at(u8, 2775);
}

pub fn festivalEnd(self: @This()) u8 {
    return self.row.at(u8, 2776);
}

/// Links to `BeastTribe`.
pub fn beastTribe(self: @This()) excel.Link(sheets.BeastTribe) {
    return .of(self.row.at(u8, 2777));
}

/// Links to `BeastReputationRank`.
pub fn beastReputationRank(self: @This()) excel.Link(sheets.BeastReputationRank) {
    return .of(self.row.at(u8, 2778));
}

/// Links to `SatisfactionNpc`.
pub fn satisfactionNpc(self: @This()) excel.Link(sheets.SatisfactionNpc) {
    return .of(self.row.at(u8, 2779));
}

pub fn satisfactionLevel(self: @This()) u8 {
    return self.row.at(u8, 2780);
}

/// Links to `DeliveryQuest`.
pub fn deliveryQuest(self: @This()) excel.Link(sheets.DeliveryQuest) {
    return .of(self.row.at(u8, 2781));
}

pub fn repeatIntervalType(self: @This()) u8 {
    return self.row.at(u8, 2782);
}

/// Links to `QuestRepeatFlag`.
pub fn questRepeatFlag(self: @This()) excel.Link(sheets.QuestRepeatFlag) {
    return .of(self.row.at(u8, 2783));
}

pub fn @"type"(self: @This()) u8 {
    return self.row.at(u8, 2784);
}

pub fn unknown_70(self: @This()) u8 {
    return self.row.at(u8, 2785);
}

pub fn levelMax(self: @This()) u8 {
    return self.row.at(u8, 2786);
}

/// Links to `ClassJob`.
pub fn classJobRequired(self: @This()) excel.Link(sheets.ClassJob) {
    return .of(self.row.at(u8, 2787));
}

/// Links to `QuestRewardOther`.
pub fn questRewardOtherDisplay(self: @This()) excel.Link(sheets.QuestRewardOther) {
    return .of(self.row.at(u8, 2788));
}

pub fn unknown10(self: @This()) u8 {
    return self.row.at(u8, 2789);
}

/// Links to `EventIconType`.
pub fn eventIconType(self: @This()) excel.Link(sheets.EventIconType) {
    return .of(self.row.at(u8, 2790));
}

/// 1/2 - normal daily beast tribe quests, 3 - 'exclusive' (if player's rank is not greater than max rank requirement of quests offered by npc, exactly one of the available quests will be from this pool)
pub fn dailyQuestPool(self: @This()) u8 {
    return self.row.at(u8, 2791);
}

pub fn isHouseRequired(self: @This()) bool {
    return self.row.bitAt(2792, 0);
}

pub fn isRepeatable(self: @This()) bool {
    return self.row.bitAt(2792, 1);
}

pub fn canCancel(self: @This()) bool {
    return self.row.bitAt(2792, 2);
}

pub fn introduction(self: @This()) bool {
    return self.row.bitAt(2792, 3);
}

pub fn hideOfferIcon(self: @This()) bool {
    return self.row.bitAt(2792, 4);
}

pub fn unknown12(self: @This()) bool {
    return self.row.bitAt(2792, 5);
}

/// Shows ??? instead.
pub fn hideInScenarioGuide(self: @This()) bool {
    return self.row.bitAt(2792, 6);
}

const offsets_1 = [50]u16{ 4, 12, 20, 28, 36, 44, 52, 60, 68, 76, 84, 92, 100, 108, 116, 124, 132, 140, 148, 156, 164, 172, 180, 188, 196, 204, 212, 220, 228, 236, 244, 252, 260, 268, 276, 284, 292, 300, 308, 316, 324, 332, 340, 348, 356, 364, 372, 380, 388, 396 };
const offsets_2 = [50]u16{ 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120, 128, 136, 144, 152, 160, 168, 176, 184, 192, 200, 208, 216, 224, 232, 240, 248, 256, 264, 272, 280, 288, 296, 304, 312, 320, 328, 336, 344, 352, 360, 368, 376, 384, 392, 400 };
const offsets_3 = [64]u16{ 404, 424, 444, 464, 484, 504, 524, 544, 564, 584, 604, 624, 644, 664, 684, 704, 724, 744, 764, 784, 804, 824, 844, 864, 884, 904, 924, 944, 964, 984, 1004, 1024, 1044, 1064, 1084, 1104, 1124, 1144, 1164, 1184, 1204, 1224, 1244, 1264, 1284, 1304, 1324, 1344, 1364, 1384, 1404, 1424, 1444, 1464, 1484, 1504, 1524, 1544, 1564, 1584, 1604, 1624, 1644, 1664 };
const offsets_4 = [64]u16{ 408, 428, 448, 468, 488, 508, 528, 548, 568, 588, 608, 628, 648, 668, 688, 708, 728, 748, 768, 788, 808, 828, 848, 868, 888, 908, 928, 948, 968, 988, 1008, 1028, 1048, 1068, 1088, 1108, 1128, 1148, 1168, 1188, 1208, 1228, 1248, 1268, 1288, 1308, 1328, 1348, 1368, 1388, 1408, 1428, 1448, 1468, 1488, 1508, 1528, 1548, 1568, 1588, 1608, 1628, 1648, 1668 };
const offsets_5 = [64]u16{ 412, 432, 452, 472, 492, 512, 532, 552, 572, 592, 612, 632, 652, 672, 692, 712, 732, 752, 772, 792, 812, 832, 852, 872, 892, 912, 932, 952, 972, 992, 1012, 1032, 1052, 1072, 1092, 1112, 1132, 1152, 1172, 1192, 1212, 1232, 1252, 1272, 1292, 1312, 1332, 1352, 1372, 1392, 1412, 1432, 1452, 1472, 1492, 1512, 1532, 1552, 1572, 1592, 1612, 1632, 1652, 1672 };
const offsets_6 = [64]u16{ 414, 434, 454, 474, 494, 514, 534, 554, 574, 594, 614, 634, 654, 674, 694, 714, 734, 754, 774, 794, 814, 834, 854, 874, 894, 914, 934, 954, 974, 994, 1014, 1034, 1054, 1074, 1094, 1114, 1134, 1154, 1174, 1194, 1214, 1234, 1254, 1274, 1294, 1314, 1334, 1354, 1374, 1394, 1414, 1434, 1454, 1474, 1494, 1514, 1534, 1554, 1574, 1594, 1614, 1634, 1654, 1674 };
const offsets_7 = [64]u16{ 415, 435, 455, 475, 495, 515, 535, 555, 575, 595, 615, 635, 655, 675, 695, 715, 735, 755, 775, 795, 815, 835, 855, 875, 895, 915, 935, 955, 975, 995, 1015, 1035, 1055, 1075, 1095, 1115, 1135, 1155, 1175, 1195, 1215, 1235, 1255, 1275, 1295, 1315, 1335, 1355, 1375, 1395, 1415, 1435, 1455, 1475, 1495, 1515, 1535, 1555, 1575, 1595, 1615, 1635, 1655, 1675 };
const offsets_8 = [64]u16{ 416, 436, 456, 476, 496, 516, 536, 556, 576, 596, 616, 636, 656, 676, 696, 716, 736, 756, 776, 796, 816, 836, 856, 876, 896, 916, 936, 956, 976, 996, 1016, 1036, 1056, 1076, 1096, 1116, 1136, 1156, 1176, 1196, 1216, 1236, 1256, 1276, 1296, 1316, 1336, 1356, 1376, 1396, 1416, 1436, 1456, 1476, 1496, 1516, 1536, 1556, 1576, 1596, 1616, 1636, 1656, 1676 };
const offsets_9 = [64]u16{ 417, 437, 457, 477, 497, 517, 537, 557, 577, 597, 617, 637, 657, 677, 697, 717, 737, 757, 777, 797, 817, 837, 857, 877, 897, 917, 937, 957, 977, 997, 1017, 1037, 1057, 1077, 1097, 1117, 1137, 1157, 1177, 1197, 1217, 1237, 1257, 1277, 1297, 1317, 1337, 1357, 1377, 1397, 1417, 1437, 1457, 1477, 1497, 1517, 1537, 1557, 1577, 1597, 1617, 1637, 1657, 1677 };
const offsets_10 = [64]u16{ 418, 438, 458, 478, 498, 518, 538, 558, 578, 598, 618, 638, 658, 678, 698, 718, 738, 758, 778, 798, 818, 838, 858, 878, 898, 918, 938, 958, 978, 998, 1018, 1038, 1058, 1078, 1098, 1118, 1138, 1158, 1178, 1198, 1218, 1238, 1258, 1278, 1298, 1318, 1338, 1358, 1378, 1398, 1418, 1438, 1458, 1478, 1498, 1518, 1538, 1558, 1578, 1598, 1618, 1638, 1658, 1678 };
const offsets_11 = [64]u16{ 419, 439, 459, 479, 499, 519, 539, 559, 579, 599, 619, 639, 659, 679, 699, 719, 739, 759, 779, 799, 819, 839, 859, 879, 899, 919, 939, 959, 979, 999, 1019, 1039, 1059, 1079, 1099, 1119, 1139, 1159, 1179, 1199, 1219, 1239, 1259, 1279, 1299, 1319, 1339, 1359, 1379, 1399, 1419, 1439, 1459, 1479, 1499, 1519, 1539, 1559, 1579, 1599, 1619, 1639, 1659, 1679 };
const offsets_12 = [64]u16{ 420, 440, 460, 480, 500, 520, 540, 560, 580, 600, 620, 640, 660, 680, 700, 720, 740, 760, 780, 800, 820, 840, 860, 880, 900, 920, 940, 960, 980, 1000, 1020, 1040, 1060, 1080, 1100, 1120, 1140, 1160, 1180, 1200, 1220, 1240, 1260, 1280, 1300, 1320, 1340, 1360, 1380, 1400, 1420, 1440, 1460, 1480, 1500, 1520, 1540, 1560, 1580, 1600, 1620, 1640, 1660, 1680 };
const offsets_13 = [64]u32{ 3368, 3528, 3688, 3848, 4008, 4168, 4328, 4488, 4648, 4808, 4968, 5128, 5288, 5448, 5608, 5768, 5928, 6088, 6248, 6408, 6568, 6728, 6888, 7048, 7208, 7368, 7528, 7688, 7848, 8008, 8168, 8328, 8488, 8648, 8808, 8968, 9128, 9288, 9448, 9608, 9768, 9928, 10088, 10248, 10408, 10568, 10728, 10888, 11048, 11208, 11368, 11528, 11688, 11848, 12008, 12168, 12328, 12488, 12648, 12808, 12968, 13128, 13288, 13448 };
const offsets_14 = [64]u32{ 3369, 3529, 3689, 3849, 4009, 4169, 4329, 4489, 4649, 4809, 4969, 5129, 5289, 5449, 5609, 5769, 5929, 6089, 6249, 6409, 6569, 6729, 6889, 7049, 7209, 7369, 7529, 7689, 7849, 8009, 8169, 8329, 8489, 8649, 8809, 8969, 9129, 9289, 9449, 9609, 9769, 9929, 10089, 10249, 10409, 10569, 10729, 10889, 11049, 11209, 11369, 11529, 11689, 11849, 12009, 12169, 12329, 12489, 12649, 12809, 12969, 13129, 13289, 13449 };
const offsets_15 = [64]u32{ 3370, 3530, 3690, 3850, 4010, 4170, 4330, 4490, 4650, 4810, 4970, 5130, 5290, 5450, 5610, 5770, 5930, 6090, 6250, 6410, 6570, 6730, 6890, 7050, 7210, 7370, 7530, 7690, 7850, 8010, 8170, 8330, 8490, 8650, 8810, 8970, 9130, 9290, 9450, 9610, 9770, 9930, 10090, 10250, 10410, 10570, 10730, 10890, 11050, 11210, 11370, 11530, 11690, 11850, 12010, 12170, 12330, 12490, 12650, 12810, 12970, 13130, 13290, 13450 };
const offsets_16 = [64]u32{ 3371, 3531, 3691, 3851, 4011, 4171, 4331, 4491, 4651, 4811, 4971, 5131, 5291, 5451, 5611, 5771, 5931, 6091, 6251, 6411, 6571, 6731, 6891, 7051, 7211, 7371, 7531, 7691, 7851, 8011, 8171, 8331, 8491, 8651, 8811, 8971, 9131, 9291, 9451, 9611, 9771, 9931, 10091, 10251, 10411, 10571, 10731, 10891, 11051, 11211, 11371, 11531, 11691, 11851, 12011, 12171, 12331, 12491, 12651, 12811, 12971, 13131, 13291, 13451 };
const offsets_17 = [64]u32{ 3372, 3532, 3692, 3852, 4012, 4172, 4332, 4492, 4652, 4812, 4972, 5132, 5292, 5452, 5612, 5772, 5932, 6092, 6252, 6412, 6572, 6732, 6892, 7052, 7212, 7372, 7532, 7692, 7852, 8012, 8172, 8332, 8492, 8652, 8812, 8972, 9132, 9292, 9452, 9612, 9772, 9932, 10092, 10252, 10412, 10572, 10732, 10892, 11052, 11212, 11372, 11532, 11692, 11852, 12012, 12172, 12332, 12492, 12652, 12812, 12972, 13132, 13292, 13452 };
const offsets_18 = [64]u32{ 3373, 3533, 3693, 3853, 4013, 4173, 4333, 4493, 4653, 4813, 4973, 5133, 5293, 5453, 5613, 5773, 5933, 6093, 6253, 6413, 6573, 6733, 6893, 7053, 7213, 7373, 7533, 7693, 7853, 8013, 8173, 8333, 8493, 8653, 8813, 8973, 9133, 9293, 9453, 9613, 9773, 9933, 10093, 10253, 10413, 10573, 10733, 10893, 11053, 11213, 11373, 11533, 11693, 11853, 12013, 12173, 12333, 12493, 12653, 12813, 12973, 13133, 13293, 13453 };
const offsets_19 = [64]u32{ 3374, 3534, 3694, 3854, 4014, 4174, 4334, 4494, 4654, 4814, 4974, 5134, 5294, 5454, 5614, 5774, 5934, 6094, 6254, 6414, 6574, 6734, 6894, 7054, 7214, 7374, 7534, 7694, 7854, 8014, 8174, 8334, 8494, 8654, 8814, 8974, 9134, 9294, 9454, 9614, 9774, 9934, 10094, 10254, 10414, 10574, 10734, 10894, 11054, 11214, 11374, 11534, 11694, 11854, 12014, 12174, 12334, 12494, 12654, 12814, 12974, 13134, 13294, 13454 };
const offsets_20 = [64]u32{ 3375, 3535, 3695, 3855, 4015, 4175, 4335, 4495, 4655, 4815, 4975, 5135, 5295, 5455, 5615, 5775, 5935, 6095, 6255, 6415, 6575, 6735, 6895, 7055, 7215, 7375, 7535, 7695, 7855, 8015, 8175, 8335, 8495, 8655, 8815, 8975, 9135, 9295, 9455, 9615, 9775, 9935, 10095, 10255, 10415, 10575, 10735, 10895, 11055, 11215, 11375, 11535, 11695, 11855, 12015, 12175, 12335, 12495, 12655, 12815, 12975, 13135, 13295, 13455 };
const offsets_21 = [24][8]u16{ .{ 1684, 1688, 1692, 1696, 1700, 1704, 1708, 1712 }, .{ 1720, 1724, 1728, 1732, 1736, 1740, 1744, 1748 }, .{ 1756, 1760, 1764, 1768, 1772, 1776, 1780, 1784 }, .{ 1792, 1796, 1800, 1804, 1808, 1812, 1816, 1820 }, .{ 1828, 1832, 1836, 1840, 1844, 1848, 1852, 1856 }, .{ 1864, 1868, 1872, 1876, 1880, 1884, 1888, 1892 }, .{ 1900, 1904, 1908, 1912, 1916, 1920, 1924, 1928 }, .{ 1936, 1940, 1944, 1948, 1952, 1956, 1960, 1964 }, .{ 1972, 1976, 1980, 1984, 1988, 1992, 1996, 2000 }, .{ 2008, 2012, 2016, 2020, 2024, 2028, 2032, 2036 }, .{ 2044, 2048, 2052, 2056, 2060, 2064, 2068, 2072 }, .{ 2080, 2084, 2088, 2092, 2096, 2100, 2104, 2108 }, .{ 2116, 2120, 2124, 2128, 2132, 2136, 2140, 2144 }, .{ 2152, 2156, 2160, 2164, 2168, 2172, 2176, 2180 }, .{ 2188, 2192, 2196, 2200, 2204, 2208, 2212, 2216 }, .{ 2224, 2228, 2232, 2236, 2240, 2244, 2248, 2252 }, .{ 2260, 2264, 2268, 2272, 2276, 2280, 2284, 2288 }, .{ 2296, 2300, 2304, 2308, 2312, 2316, 2320, 2324 }, .{ 2332, 2336, 2340, 2344, 2348, 2352, 2356, 2360 }, .{ 2368, 2372, 2376, 2380, 2384, 2388, 2392, 2396 }, .{ 2404, 2408, 2412, 2416, 2420, 2424, 2428, 2432 }, .{ 2440, 2444, 2448, 2452, 2456, 2460, 2464, 2468 }, .{ 2476, 2480, 2484, 2488, 2492, 2496, 2500, 2504 }, .{ 2512, 2516, 2520, 2524, 2528, 2532, 2536, 2540 } };
const offsets_22 = [24]u16{ 1716, 1752, 1788, 1824, 1860, 1896, 1932, 1968, 2004, 2040, 2076, 2112, 2148, 2184, 2220, 2256, 2292, 2328, 2364, 2400, 2436, 2472, 2508, 2544 };
const offsets_23 = [24]u16{ 1717, 1753, 1789, 1825, 1861, 1897, 1933, 1969, 2005, 2041, 2077, 2113, 2149, 2185, 2221, 2257, 2293, 2329, 2365, 2401, 2437, 2473, 2509, 2545 };
const offsets_24 = [24]u16{ 1718, 1754, 1790, 1826, 1862, 1898, 1934, 1970, 2006, 2042, 2078, 2114, 2150, 2186, 2222, 2258, 2294, 2330, 2366, 2402, 2438, 2474, 2510, 2546 };
const offsets_25 = [7]u16{ 2560, 2564, 2568, 2572, 2576, 2580, 2584 };
const offsets_26 = [5]u16{ 2588, 2592, 2596, 2600, 2604 };
const offsets_27 = [2]u16{ 2618, 2620 };
const offsets_28 = [3]u16{ 2624, 2625, 2626 };
const offsets_29 = [3]u16{ 2627, 2628, 2629 };
const offsets_30 = [7]u16{ 2631, 2632, 2633, 2634, 2635, 2636, 2637 };
const offsets_31 = [7]u16{ 2638, 2639, 2640, 2641, 2642, 2643, 2644 };
const offsets_32 = [5]u16{ 2645, 2646, 2647, 2648, 2649 };
const offsets_33 = [5]u16{ 2650, 2651, 2652, 2653, 2654 };
const offsets_34 = [2]u16{ 2655, 2656 };
const offsets_35 = [5]u16{ 2669, 2670, 2671, 2672, 2673 };
const offsets_36 = [3]u16{ 2680, 2684, 2688 };
const offsets_37 = [2]u16{ 2692, 2696 };
const offsets_38 = [3]u16{ 2700, 2704, 2708 };
const offsets_39 = [2]u16{ 2740, 2742 };
