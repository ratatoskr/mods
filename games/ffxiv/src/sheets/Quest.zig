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

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "Id", "Expansion", "ClassJobCategory0", "ClassJobLevel[0]", "QuestLevelOffset", "ClassJobCategory1", "ClassJobLevel[1]", "PreviousQuestJoin", "PreviousQuest[0]", "Unknown7", "PreviousQuest[1]", "PreviousQuest[2]", "QuestLockJoin", "QuestLock[0]", "QuestLock[1]", "Header", "Unknown8", "Unknown9", "ClassJobUnlock", "GrandCompany", "GrandCompanyRank", "InstanceContentJoin", "InstanceContent[0]", "InstanceContent[1]", "InstanceContent[2]", "Festival", "FestivalBegin", "FestivalEnd", "BellStart", "BellEnd", "BeastTribe", "BeastReputationRank", "BeastReputationValue", "SatisfactionNpc", "SatisfactionLevel", "MountRequired", "IsHouseRequired", "DeliveryQuest", "IssuerStart", "IssuerLocation", "ClientBehavior", "TargetEnd", "IsRepeatable", "RepeatIntervalType", "QuestRepeatFlag", "CanCancel", "Type", "QuestClassJobSupply", "Unknown_70", "QuestParams[0].ScriptInstruction", "QuestParams[1].ScriptInstruction", "QuestParams[2].ScriptInstruction", "QuestParams[3].ScriptInstruction", "QuestParams[4].ScriptInstruction", "QuestParams[5].ScriptInstruction", "QuestParams[6].ScriptInstruction", "QuestParams[7].ScriptInstruction", "QuestParams[8].ScriptInstruction", "QuestParams[9].ScriptInstruction", "QuestParams[10].ScriptInstruction", "QuestParams[11].ScriptInstruction", "QuestParams[12].ScriptInstruction", "QuestParams[13].ScriptInstruction", "QuestParams[14].ScriptInstruction", "QuestParams[15].ScriptInstruction", "QuestParams[16].ScriptInstruction", "QuestParams[17].ScriptInstruction", "QuestParams[18].ScriptInstruction", "QuestParams[19].ScriptInstruction", "QuestParams[20].ScriptInstruction", "QuestParams[21].ScriptInstruction", "QuestParams[22].ScriptInstruction", "QuestParams[23].ScriptInstruction", "QuestParams[24].ScriptInstruction", "QuestParams[25].ScriptInstruction", "QuestParams[26].ScriptInstruction", "QuestParams[27].ScriptInstruction", "QuestParams[28].ScriptInstruction", "QuestParams[29].ScriptInstruction", "QuestParams[30].ScriptInstruction", "QuestParams[31].ScriptInstruction", "QuestParams[32].ScriptInstruction", "QuestParams[33].ScriptInstruction", "QuestParams[34].ScriptInstruction", "QuestParams[35].ScriptInstruction", "QuestParams[36].ScriptInstruction", "QuestParams[37].ScriptInstruction", "QuestParams[38].ScriptInstruction", "QuestParams[39].ScriptInstruction", "QuestParams[40].ScriptInstruction", "QuestParams[41].ScriptInstruction", "QuestParams[42].ScriptInstruction", "QuestParams[43].ScriptInstruction", "QuestParams[44].ScriptInstruction", "QuestParams[45].ScriptInstruction", "QuestParams[46].ScriptInstruction", "QuestParams[47].ScriptInstruction", "QuestParams[48].ScriptInstruction", "QuestParams[49].ScriptInstruction", "QuestParams[0].ScriptArg", "QuestParams[1].ScriptArg", "QuestParams[2].ScriptArg", "QuestParams[3].ScriptArg", "QuestParams[4].ScriptArg", "QuestParams[5].ScriptArg", "QuestParams[6].ScriptArg", "QuestParams[7].ScriptArg", "QuestParams[8].ScriptArg", "QuestParams[9].ScriptArg", "QuestParams[10].ScriptArg", "QuestParams[11].ScriptArg", "QuestParams[12].ScriptArg", "QuestParams[13].ScriptArg", "QuestParams[14].ScriptArg", "QuestParams[15].ScriptArg", "QuestParams[16].ScriptArg", "QuestParams[17].ScriptArg", "QuestParams[18].ScriptArg", "QuestParams[19].ScriptArg", "QuestParams[20].ScriptArg", "QuestParams[21].ScriptArg", "QuestParams[22].ScriptArg", "QuestParams[23].ScriptArg", "QuestParams[24].ScriptArg", "QuestParams[25].ScriptArg", "QuestParams[26].ScriptArg", "QuestParams[27].ScriptArg", "QuestParams[28].ScriptArg", "QuestParams[29].ScriptArg", "QuestParams[30].ScriptArg", "QuestParams[31].ScriptArg", "QuestParams[32].ScriptArg", "QuestParams[33].ScriptArg", "QuestParams[34].ScriptArg", "QuestParams[35].ScriptArg", "QuestParams[36].ScriptArg", "QuestParams[37].ScriptArg", "QuestParams[38].ScriptArg", "QuestParams[39].ScriptArg", "QuestParams[40].ScriptArg", "QuestParams[41].ScriptArg", "QuestParams[42].ScriptArg", "QuestParams[43].ScriptArg", "QuestParams[44].ScriptArg", "QuestParams[45].ScriptArg", "QuestParams[46].ScriptArg", "QuestParams[47].ScriptArg", "QuestParams[48].ScriptArg", "QuestParams[49].ScriptArg", "QuestListenerParams[0].ActorSpawnSeq", "QuestListenerParams[1].ActorSpawnSeq", "QuestListenerParams[2].ActorSpawnSeq", "QuestListenerParams[3].ActorSpawnSeq", "QuestListenerParams[4].ActorSpawnSeq", "QuestListenerParams[5].ActorSpawnSeq", "QuestListenerParams[6].ActorSpawnSeq", "QuestListenerParams[7].ActorSpawnSeq", "QuestListenerParams[8].ActorSpawnSeq", "QuestListenerParams[9].ActorSpawnSeq", "QuestListenerParams[10].ActorSpawnSeq", "QuestListenerParams[11].ActorSpawnSeq", "QuestListenerParams[12].ActorSpawnSeq", "QuestListenerParams[13].ActorSpawnSeq", "QuestListenerParams[14].ActorSpawnSeq", "QuestListenerParams[15].ActorSpawnSeq", "QuestListenerParams[16].ActorSpawnSeq", "QuestListenerParams[17].ActorSpawnSeq", "QuestListenerParams[18].ActorSpawnSeq", "QuestListenerParams[19].ActorSpawnSeq", "QuestListenerParams[20].ActorSpawnSeq", "QuestListenerParams[21].ActorSpawnSeq", "QuestListenerParams[22].ActorSpawnSeq", "QuestListenerParams[23].ActorSpawnSeq", "QuestListenerParams[24].ActorSpawnSeq", "QuestListenerParams[25].ActorSpawnSeq", "QuestListenerParams[26].ActorSpawnSeq", "QuestListenerParams[27].ActorSpawnSeq", "QuestListenerParams[28].ActorSpawnSeq", "QuestListenerParams[29].ActorSpawnSeq", "QuestListenerParams[30].ActorSpawnSeq", "QuestListenerParams[31].ActorSpawnSeq", "QuestListenerParams[32].ActorSpawnSeq", "QuestListenerParams[33].ActorSpawnSeq", "QuestListenerParams[34].ActorSpawnSeq", "QuestListenerParams[35].ActorSpawnSeq", "QuestListenerParams[36].ActorSpawnSeq", "QuestListenerParams[37].ActorSpawnSeq", "QuestListenerParams[38].ActorSpawnSeq", "QuestListenerParams[39].ActorSpawnSeq", "QuestListenerParams[40].ActorSpawnSeq", "QuestListenerParams[41].ActorSpawnSeq", "QuestListenerParams[42].ActorSpawnSeq", "QuestListenerParams[43].ActorSpawnSeq", "QuestListenerParams[44].ActorSpawnSeq", "QuestListenerParams[45].ActorSpawnSeq", "QuestListenerParams[46].ActorSpawnSeq", "QuestListenerParams[47].ActorSpawnSeq", "QuestListenerParams[48].ActorSpawnSeq", "QuestListenerParams[49].ActorSpawnSeq", "QuestListenerParams[50].ActorSpawnSeq", "QuestListenerParams[51].ActorSpawnSeq", "QuestListenerParams[52].ActorSpawnSeq", "QuestListenerParams[53].ActorSpawnSeq", "QuestListenerParams[54].ActorSpawnSeq", "QuestListenerParams[55].ActorSpawnSeq", "QuestListenerParams[56].ActorSpawnSeq", "QuestListenerParams[57].ActorSpawnSeq", "QuestListenerParams[58].ActorSpawnSeq", "QuestListenerParams[59].ActorSpawnSeq", "QuestListenerParams[60].ActorSpawnSeq", "QuestListenerParams[61].ActorSpawnSeq", "QuestListenerParams[62].ActorSpawnSeq", "QuestListenerParams[63].ActorSpawnSeq", "QuestListenerParams[0].ActorDespawnSeq", "QuestListenerParams[1].ActorDespawnSeq", "QuestListenerParams[2].ActorDespawnSeq", "QuestListenerParams[3].ActorDespawnSeq", "QuestListenerParams[4].ActorDespawnSeq", "QuestListenerParams[5].ActorDespawnSeq", "QuestListenerParams[6].ActorDespawnSeq", "QuestListenerParams[7].ActorDespawnSeq", "QuestListenerParams[8].ActorDespawnSeq", "QuestListenerParams[9].ActorDespawnSeq", "QuestListenerParams[10].ActorDespawnSeq", "QuestListenerParams[11].ActorDespawnSeq", "QuestListenerParams[12].ActorDespawnSeq", "QuestListenerParams[13].ActorDespawnSeq", "QuestListenerParams[14].ActorDespawnSeq", "QuestListenerParams[15].ActorDespawnSeq", "QuestListenerParams[16].ActorDespawnSeq", "QuestListenerParams[17].ActorDespawnSeq", "QuestListenerParams[18].ActorDespawnSeq", "QuestListenerParams[19].ActorDespawnSeq", "QuestListenerParams[20].ActorDespawnSeq", "QuestListenerParams[21].ActorDespawnSeq", "QuestListenerParams[22].ActorDespawnSeq", "QuestListenerParams[23].ActorDespawnSeq", "QuestListenerParams[24].ActorDespawnSeq", "QuestListenerParams[25].ActorDespawnSeq", "QuestListenerParams[26].ActorDespawnSeq", "QuestListenerParams[27].ActorDespawnSeq", "QuestListenerParams[28].ActorDespawnSeq", "QuestListenerParams[29].ActorDespawnSeq", "QuestListenerParams[30].ActorDespawnSeq", "QuestListenerParams[31].ActorDespawnSeq", "QuestListenerParams[32].ActorDespawnSeq", "QuestListenerParams[33].ActorDespawnSeq", "QuestListenerParams[34].ActorDespawnSeq", "QuestListenerParams[35].ActorDespawnSeq", "QuestListenerParams[36].ActorDespawnSeq", "QuestListenerParams[37].ActorDespawnSeq", "QuestListenerParams[38].ActorDespawnSeq", "QuestListenerParams[39].ActorDespawnSeq", "QuestListenerParams[40].ActorDespawnSeq", "QuestListenerParams[41].ActorDespawnSeq", "QuestListenerParams[42].ActorDespawnSeq", "QuestListenerParams[43].ActorDespawnSeq", "QuestListenerParams[44].ActorDespawnSeq", "QuestListenerParams[45].ActorDespawnSeq", "QuestListenerParams[46].ActorDespawnSeq", "QuestListenerParams[47].ActorDespawnSeq", "QuestListenerParams[48].ActorDespawnSeq", "QuestListenerParams[49].ActorDespawnSeq", "QuestListenerParams[50].ActorDespawnSeq", "QuestListenerParams[51].ActorDespawnSeq", "QuestListenerParams[52].ActorDespawnSeq", "QuestListenerParams[53].ActorDespawnSeq", "QuestListenerParams[54].ActorDespawnSeq", "QuestListenerParams[55].ActorDespawnSeq", "QuestListenerParams[56].ActorDespawnSeq", "QuestListenerParams[57].ActorDespawnSeq", "QuestListenerParams[58].ActorDespawnSeq", "QuestListenerParams[59].ActorDespawnSeq", "QuestListenerParams[60].ActorDespawnSeq", "QuestListenerParams[61].ActorDespawnSeq", "QuestListenerParams[62].ActorDespawnSeq", "QuestListenerParams[63].ActorDespawnSeq", "QuestListenerParams[0].Unknown0", "QuestListenerParams[1].Unknown0", "QuestListenerParams[2].Unknown0", "QuestListenerParams[3].Unknown0", "QuestListenerParams[4].Unknown0", "QuestListenerParams[5].Unknown0", "QuestListenerParams[6].Unknown0", "QuestListenerParams[7].Unknown0", "QuestListenerParams[8].Unknown0", "QuestListenerParams[9].Unknown0", "QuestListenerParams[10].Unknown0", "QuestListenerParams[11].Unknown0", "QuestListenerParams[12].Unknown0", "QuestListenerParams[13].Unknown0", "QuestListenerParams[14].Unknown0", "QuestListenerParams[15].Unknown0", "QuestListenerParams[16].Unknown0", "QuestListenerParams[17].Unknown0", "QuestListenerParams[18].Unknown0", "QuestListenerParams[19].Unknown0", "QuestListenerParams[20].Unknown0", "QuestListenerParams[21].Unknown0", "QuestListenerParams[22].Unknown0", "QuestListenerParams[23].Unknown0", "QuestListenerParams[24].Unknown0", "QuestListenerParams[25].Unknown0", "QuestListenerParams[26].Unknown0", "QuestListenerParams[27].Unknown0", "QuestListenerParams[28].Unknown0", "QuestListenerParams[29].Unknown0", "QuestListenerParams[30].Unknown0", "QuestListenerParams[31].Unknown0", "QuestListenerParams[32].Unknown0", "QuestListenerParams[33].Unknown0", "QuestListenerParams[34].Unknown0", "QuestListenerParams[35].Unknown0", "QuestListenerParams[36].Unknown0", "QuestListenerParams[37].Unknown0", "QuestListenerParams[38].Unknown0", "QuestListenerParams[39].Unknown0", "QuestListenerParams[40].Unknown0", "QuestListenerParams[41].Unknown0", "QuestListenerParams[42].Unknown0", "QuestListenerParams[43].Unknown0", "QuestListenerParams[44].Unknown0", "QuestListenerParams[45].Unknown0", "QuestListenerParams[46].Unknown0", "QuestListenerParams[47].Unknown0", "QuestListenerParams[48].Unknown0", "QuestListenerParams[49].Unknown0", "QuestListenerParams[50].Unknown0", "QuestListenerParams[51].Unknown0", "QuestListenerParams[52].Unknown0", "QuestListenerParams[53].Unknown0", "QuestListenerParams[54].Unknown0", "QuestListenerParams[55].Unknown0", "QuestListenerParams[56].Unknown0", "QuestListenerParams[57].Unknown0", "QuestListenerParams[58].Unknown0", "QuestListenerParams[59].Unknown0", "QuestListenerParams[60].Unknown0", "QuestListenerParams[61].Unknown0", "QuestListenerParams[62].Unknown0", "QuestListenerParams[63].Unknown0", "QuestListenerParams[0].Unknown1", "QuestListenerParams[1].Unknown1", "QuestListenerParams[2].Unknown1", "QuestListenerParams[3].Unknown1", "QuestListenerParams[4].Unknown1", "QuestListenerParams[5].Unknown1", "QuestListenerParams[6].Unknown1", "QuestListenerParams[7].Unknown1", "QuestListenerParams[8].Unknown1", "QuestListenerParams[9].Unknown1", "QuestListenerParams[10].Unknown1", "QuestListenerParams[11].Unknown1", "QuestListenerParams[12].Unknown1", "QuestListenerParams[13].Unknown1", "QuestListenerParams[14].Unknown1", "QuestListenerParams[15].Unknown1", "QuestListenerParams[16].Unknown1", "QuestListenerParams[17].Unknown1", "QuestListenerParams[18].Unknown1", "QuestListenerParams[19].Unknown1", "QuestListenerParams[20].Unknown1", "QuestListenerParams[21].Unknown1", "QuestListenerParams[22].Unknown1", "QuestListenerParams[23].Unknown1", "QuestListenerParams[24].Unknown1", "QuestListenerParams[25].Unknown1", "QuestListenerParams[26].Unknown1", "QuestListenerParams[27].Unknown1", "QuestListenerParams[28].Unknown1", "QuestListenerParams[29].Unknown1", "QuestListenerParams[30].Unknown1", "QuestListenerParams[31].Unknown1", "QuestListenerParams[32].Unknown1", "QuestListenerParams[33].Unknown1", "QuestListenerParams[34].Unknown1", "QuestListenerParams[35].Unknown1", "QuestListenerParams[36].Unknown1", "QuestListenerParams[37].Unknown1", "QuestListenerParams[38].Unknown1", "QuestListenerParams[39].Unknown1", "QuestListenerParams[40].Unknown1", "QuestListenerParams[41].Unknown1", "QuestListenerParams[42].Unknown1", "QuestListenerParams[43].Unknown1", "QuestListenerParams[44].Unknown1", "QuestListenerParams[45].Unknown1", "QuestListenerParams[46].Unknown1", "QuestListenerParams[47].Unknown1", "QuestListenerParams[48].Unknown1", "QuestListenerParams[49].Unknown1", "QuestListenerParams[50].Unknown1", "QuestListenerParams[51].Unknown1", "QuestListenerParams[52].Unknown1", "QuestListenerParams[53].Unknown1", "QuestListenerParams[54].Unknown1", "QuestListenerParams[55].Unknown1", "QuestListenerParams[56].Unknown1", "QuestListenerParams[57].Unknown1", "QuestListenerParams[58].Unknown1", "QuestListenerParams[59].Unknown1", "QuestListenerParams[60].Unknown1", "QuestListenerParams[61].Unknown1", "QuestListenerParams[62].Unknown1", "QuestListenerParams[63].Unknown1", "QuestListenerParams[0].Listener", "QuestListenerParams[1].Listener", "QuestListenerParams[2].Listener", "QuestListenerParams[3].Listener", "QuestListenerParams[4].Listener", "QuestListenerParams[5].Listener", "QuestListenerParams[6].Listener", "QuestListenerParams[7].Listener", "QuestListenerParams[8].Listener", "QuestListenerParams[9].Listener", "QuestListenerParams[10].Listener", "QuestListenerParams[11].Listener", "QuestListenerParams[12].Listener", "QuestListenerParams[13].Listener", "QuestListenerParams[14].Listener", "QuestListenerParams[15].Listener", "QuestListenerParams[16].Listener", "QuestListenerParams[17].Listener", "QuestListenerParams[18].Listener", "QuestListenerParams[19].Listener", "QuestListenerParams[20].Listener", "QuestListenerParams[21].Listener", "QuestListenerParams[22].Listener", "QuestListenerParams[23].Listener", "QuestListenerParams[24].Listener", "QuestListenerParams[25].Listener", "QuestListenerParams[26].Listener", "QuestListenerParams[27].Listener", "QuestListenerParams[28].Listener", "QuestListenerParams[29].Listener", "QuestListenerParams[30].Listener", "QuestListenerParams[31].Listener", "QuestListenerParams[32].Listener", "QuestListenerParams[33].Listener", "QuestListenerParams[34].Listener", "QuestListenerParams[35].Listener", "QuestListenerParams[36].Listener", "QuestListenerParams[37].Listener", "QuestListenerParams[38].Listener", "QuestListenerParams[39].Listener", "QuestListenerParams[40].Listener", "QuestListenerParams[41].Listener", "QuestListenerParams[42].Listener", "QuestListenerParams[43].Listener", "QuestListenerParams[44].Listener", "QuestListenerParams[45].Listener", "QuestListenerParams[46].Listener", "QuestListenerParams[47].Listener", "QuestListenerParams[48].Listener", "QuestListenerParams[49].Listener", "QuestListenerParams[50].Listener", "QuestListenerParams[51].Listener", "QuestListenerParams[52].Listener", "QuestListenerParams[53].Listener", "QuestListenerParams[54].Listener", "QuestListenerParams[55].Listener", "QuestListenerParams[56].Listener", "QuestListenerParams[57].Listener", "QuestListenerParams[58].Listener", "QuestListenerParams[59].Listener", "QuestListenerParams[60].Listener", "QuestListenerParams[61].Listener", "QuestListenerParams[62].Listener", "QuestListenerParams[63].Listener", "QuestListenerParams[0].QuestUInt8A", "QuestListenerParams[1].QuestUInt8A", "QuestListenerParams[2].QuestUInt8A", "QuestListenerParams[3].QuestUInt8A", "QuestListenerParams[4].QuestUInt8A", "QuestListenerParams[5].QuestUInt8A", "QuestListenerParams[6].QuestUInt8A", "QuestListenerParams[7].QuestUInt8A", "QuestListenerParams[8].QuestUInt8A", "QuestListenerParams[9].QuestUInt8A", "QuestListenerParams[10].QuestUInt8A", "QuestListenerParams[11].QuestUInt8A", "QuestListenerParams[12].QuestUInt8A", "QuestListenerParams[13].QuestUInt8A", "QuestListenerParams[14].QuestUInt8A", "QuestListenerParams[15].QuestUInt8A", "QuestListenerParams[16].QuestUInt8A", "QuestListenerParams[17].QuestUInt8A", "QuestListenerParams[18].QuestUInt8A", "QuestListenerParams[19].QuestUInt8A", "QuestListenerParams[20].QuestUInt8A", "QuestListenerParams[21].QuestUInt8A", "QuestListenerParams[22].QuestUInt8A", "QuestListenerParams[23].QuestUInt8A", "QuestListenerParams[24].QuestUInt8A", "QuestListenerParams[25].QuestUInt8A", "QuestListenerParams[26].QuestUInt8A", "QuestListenerParams[27].QuestUInt8A", "QuestListenerParams[28].QuestUInt8A", "QuestListenerParams[29].QuestUInt8A", "QuestListenerParams[30].QuestUInt8A", "QuestListenerParams[31].QuestUInt8A", "QuestListenerParams[32].QuestUInt8A", "QuestListenerParams[33].QuestUInt8A", "QuestListenerParams[34].QuestUInt8A", "QuestListenerParams[35].QuestUInt8A", "QuestListenerParams[36].QuestUInt8A", "QuestListenerParams[37].QuestUInt8A", "QuestListenerParams[38].QuestUInt8A", "QuestListenerParams[39].QuestUInt8A", "QuestListenerParams[40].QuestUInt8A", "QuestListenerParams[41].QuestUInt8A", "QuestListenerParams[42].QuestUInt8A", "QuestListenerParams[43].QuestUInt8A", "QuestListenerParams[44].QuestUInt8A", "QuestListenerParams[45].QuestUInt8A", "QuestListenerParams[46].QuestUInt8A", "QuestListenerParams[47].QuestUInt8A", "QuestListenerParams[48].QuestUInt8A", "QuestListenerParams[49].QuestUInt8A", "QuestListenerParams[50].QuestUInt8A", "QuestListenerParams[51].QuestUInt8A", "QuestListenerParams[52].QuestUInt8A", "QuestListenerParams[53].QuestUInt8A", "QuestListenerParams[54].QuestUInt8A", "QuestListenerParams[55].QuestUInt8A", "QuestListenerParams[56].QuestUInt8A", "QuestListenerParams[57].QuestUInt8A", "QuestListenerParams[58].QuestUInt8A", "QuestListenerParams[59].QuestUInt8A", "QuestListenerParams[60].QuestUInt8A", "QuestListenerParams[61].QuestUInt8A", "QuestListenerParams[62].QuestUInt8A", "QuestListenerParams[63].QuestUInt8A", "QuestListenerParams[0].ConditionType", "QuestListenerParams[1].ConditionType", "QuestListenerParams[2].ConditionType", "QuestListenerParams[3].ConditionType", "QuestListenerParams[4].ConditionType", "QuestListenerParams[5].ConditionType", "QuestListenerParams[6].ConditionType", "QuestListenerParams[7].ConditionType", "QuestListenerParams[8].ConditionType", "QuestListenerParams[9].ConditionType", "QuestListenerParams[10].ConditionType", "QuestListenerParams[11].ConditionType", "QuestListenerParams[12].ConditionType", "QuestListenerParams[13].ConditionType", "QuestListenerParams[14].ConditionType", "QuestListenerParams[15].ConditionType", "QuestListenerParams[16].ConditionType", "QuestListenerParams[17].ConditionType", "QuestListenerParams[18].ConditionType", "QuestListenerParams[19].ConditionType", "QuestListenerParams[20].ConditionType", "QuestListenerParams[21].ConditionType", "QuestListenerParams[22].ConditionType", "QuestListenerParams[23].ConditionType", "QuestListenerParams[24].ConditionType", "QuestListenerParams[25].ConditionType", "QuestListenerParams[26].ConditionType", "QuestListenerParams[27].ConditionType", "QuestListenerParams[28].ConditionType", "QuestListenerParams[29].ConditionType", "QuestListenerParams[30].ConditionType", "QuestListenerParams[31].ConditionType", "QuestListenerParams[32].ConditionType", "QuestListenerParams[33].ConditionType", "QuestListenerParams[34].ConditionType", "QuestListenerParams[35].ConditionType", "QuestListenerParams[36].ConditionType", "QuestListenerParams[37].ConditionType", "QuestListenerParams[38].ConditionType", "QuestListenerParams[39].ConditionType", "QuestListenerParams[40].ConditionType", "QuestListenerParams[41].ConditionType", "QuestListenerParams[42].ConditionType", "QuestListenerParams[43].ConditionType", "QuestListenerParams[44].ConditionType", "QuestListenerParams[45].ConditionType", "QuestListenerParams[46].ConditionType", "QuestListenerParams[47].ConditionType", "QuestListenerParams[48].ConditionType", "QuestListenerParams[49].ConditionType", "QuestListenerParams[50].ConditionType", "QuestListenerParams[51].ConditionType", "QuestListenerParams[52].ConditionType", "QuestListenerParams[53].ConditionType", "QuestListenerParams[54].ConditionType", "QuestListenerParams[55].ConditionType", "QuestListenerParams[56].ConditionType", "QuestListenerParams[57].ConditionType", "QuestListenerParams[58].ConditionType", "QuestListenerParams[59].ConditionType", "QuestListenerParams[60].ConditionType", "QuestListenerParams[61].ConditionType", "QuestListenerParams[62].ConditionType", "QuestListenerParams[63].ConditionType", "QuestListenerParams[0].ConditionValue", "QuestListenerParams[1].ConditionValue", "QuestListenerParams[2].ConditionValue", "QuestListenerParams[3].ConditionValue", "QuestListenerParams[4].ConditionValue", "QuestListenerParams[5].ConditionValue", "QuestListenerParams[6].ConditionValue", "QuestListenerParams[7].ConditionValue", "QuestListenerParams[8].ConditionValue", "QuestListenerParams[9].ConditionValue", "QuestListenerParams[10].ConditionValue", "QuestListenerParams[11].ConditionValue", "QuestListenerParams[12].ConditionValue", "QuestListenerParams[13].ConditionValue", "QuestListenerParams[14].ConditionValue", "QuestListenerParams[15].ConditionValue", "QuestListenerParams[16].ConditionValue", "QuestListenerParams[17].ConditionValue", "QuestListenerParams[18].ConditionValue", "QuestListenerParams[19].ConditionValue", "QuestListenerParams[20].ConditionValue", "QuestListenerParams[21].ConditionValue", "QuestListenerParams[22].ConditionValue", "QuestListenerParams[23].ConditionValue", "QuestListenerParams[24].ConditionValue", "QuestListenerParams[25].ConditionValue", "QuestListenerParams[26].ConditionValue", "QuestListenerParams[27].ConditionValue", "QuestListenerParams[28].ConditionValue", "QuestListenerParams[29].ConditionValue", "QuestListenerParams[30].ConditionValue", "QuestListenerParams[31].ConditionValue", "QuestListenerParams[32].ConditionValue", "QuestListenerParams[33].ConditionValue", "QuestListenerParams[34].ConditionValue", "QuestListenerParams[35].ConditionValue", "QuestListenerParams[36].ConditionValue", "QuestListenerParams[37].ConditionValue", "QuestListenerParams[38].ConditionValue", "QuestListenerParams[39].ConditionValue", "QuestListenerParams[40].ConditionValue", "QuestListenerParams[41].ConditionValue", "QuestListenerParams[42].ConditionValue", "QuestListenerParams[43].ConditionValue", "QuestListenerParams[44].ConditionValue", "QuestListenerParams[45].ConditionValue", "QuestListenerParams[46].ConditionValue", "QuestListenerParams[47].ConditionValue", "QuestListenerParams[48].ConditionValue", "QuestListenerParams[49].ConditionValue", "QuestListenerParams[50].ConditionValue", "QuestListenerParams[51].ConditionValue", "QuestListenerParams[52].ConditionValue", "QuestListenerParams[53].ConditionValue", "QuestListenerParams[54].ConditionValue", "QuestListenerParams[55].ConditionValue", "QuestListenerParams[56].ConditionValue", "QuestListenerParams[57].ConditionValue", "QuestListenerParams[58].ConditionValue", "QuestListenerParams[59].ConditionValue", "QuestListenerParams[60].ConditionValue", "QuestListenerParams[61].ConditionValue", "QuestListenerParams[62].ConditionValue", "QuestListenerParams[63].ConditionValue", "QuestListenerParams[0].ConditionOperator", "QuestListenerParams[1].ConditionOperator", "QuestListenerParams[2].ConditionOperator", "QuestListenerParams[3].ConditionOperator", "QuestListenerParams[4].ConditionOperator", "QuestListenerParams[5].ConditionOperator", "QuestListenerParams[6].ConditionOperator", "QuestListenerParams[7].ConditionOperator", "QuestListenerParams[8].ConditionOperator", "QuestListenerParams[9].ConditionOperator", "QuestListenerParams[10].ConditionOperator", "QuestListenerParams[11].ConditionOperator", "QuestListenerParams[12].ConditionOperator", "QuestListenerParams[13].ConditionOperator", "QuestListenerParams[14].ConditionOperator", "QuestListenerParams[15].ConditionOperator", "QuestListenerParams[16].ConditionOperator", "QuestListenerParams[17].ConditionOperator", "QuestListenerParams[18].ConditionOperator", "QuestListenerParams[19].ConditionOperator", "QuestListenerParams[20].ConditionOperator", "QuestListenerParams[21].ConditionOperator", "QuestListenerParams[22].ConditionOperator", "QuestListenerParams[23].ConditionOperator", "QuestListenerParams[24].ConditionOperator", "QuestListenerParams[25].ConditionOperator", "QuestListenerParams[26].ConditionOperator", "QuestListenerParams[27].ConditionOperator", "QuestListenerParams[28].ConditionOperator", "QuestListenerParams[29].ConditionOperator", "QuestListenerParams[30].ConditionOperator", "QuestListenerParams[31].ConditionOperator", "QuestListenerParams[32].ConditionOperator", "QuestListenerParams[33].ConditionOperator", "QuestListenerParams[34].ConditionOperator", "QuestListenerParams[35].ConditionOperator", "QuestListenerParams[36].ConditionOperator", "QuestListenerParams[37].ConditionOperator", "QuestListenerParams[38].ConditionOperator", "QuestListenerParams[39].ConditionOperator", "QuestListenerParams[40].ConditionOperator", "QuestListenerParams[41].ConditionOperator", "QuestListenerParams[42].ConditionOperator", "QuestListenerParams[43].ConditionOperator", "QuestListenerParams[44].ConditionOperator", "QuestListenerParams[45].ConditionOperator", "QuestListenerParams[46].ConditionOperator", "QuestListenerParams[47].ConditionOperator", "QuestListenerParams[48].ConditionOperator", "QuestListenerParams[49].ConditionOperator", "QuestListenerParams[50].ConditionOperator", "QuestListenerParams[51].ConditionOperator", "QuestListenerParams[52].ConditionOperator", "QuestListenerParams[53].ConditionOperator", "QuestListenerParams[54].ConditionOperator", "QuestListenerParams[55].ConditionOperator", "QuestListenerParams[56].ConditionOperator", "QuestListenerParams[57].ConditionOperator", "QuestListenerParams[58].ConditionOperator", "QuestListenerParams[59].ConditionOperator", "QuestListenerParams[60].ConditionOperator", "QuestListenerParams[61].ConditionOperator", "QuestListenerParams[62].ConditionOperator", "QuestListenerParams[63].ConditionOperator", "QuestListenerParams[0].Behavior", "QuestListenerParams[1].Behavior", "QuestListenerParams[2].Behavior", "QuestListenerParams[3].Behavior", "QuestListenerParams[4].Behavior", "QuestListenerParams[5].Behavior", "QuestListenerParams[6].Behavior", "QuestListenerParams[7].Behavior", "QuestListenerParams[8].Behavior", "QuestListenerParams[9].Behavior", "QuestListenerParams[10].Behavior", "QuestListenerParams[11].Behavior", "QuestListenerParams[12].Behavior", "QuestListenerParams[13].Behavior", "QuestListenerParams[14].Behavior", "QuestListenerParams[15].Behavior", "QuestListenerParams[16].Behavior", "QuestListenerParams[17].Behavior", "QuestListenerParams[18].Behavior", "QuestListenerParams[19].Behavior", "QuestListenerParams[20].Behavior", "QuestListenerParams[21].Behavior", "QuestListenerParams[22].Behavior", "QuestListenerParams[23].Behavior", "QuestListenerParams[24].Behavior", "QuestListenerParams[25].Behavior", "QuestListenerParams[26].Behavior", "QuestListenerParams[27].Behavior", "QuestListenerParams[28].Behavior", "QuestListenerParams[29].Behavior", "QuestListenerParams[30].Behavior", "QuestListenerParams[31].Behavior", "QuestListenerParams[32].Behavior", "QuestListenerParams[33].Behavior", "QuestListenerParams[34].Behavior", "QuestListenerParams[35].Behavior", "QuestListenerParams[36].Behavior", "QuestListenerParams[37].Behavior", "QuestListenerParams[38].Behavior", "QuestListenerParams[39].Behavior", "QuestListenerParams[40].Behavior", "QuestListenerParams[41].Behavior", "QuestListenerParams[42].Behavior", "QuestListenerParams[43].Behavior", "QuestListenerParams[44].Behavior", "QuestListenerParams[45].Behavior", "QuestListenerParams[46].Behavior", "QuestListenerParams[47].Behavior", "QuestListenerParams[48].Behavior", "QuestListenerParams[49].Behavior", "QuestListenerParams[50].Behavior", "QuestListenerParams[51].Behavior", "QuestListenerParams[52].Behavior", "QuestListenerParams[53].Behavior", "QuestListenerParams[54].Behavior", "QuestListenerParams[55].Behavior", "QuestListenerParams[56].Behavior", "QuestListenerParams[57].Behavior", "QuestListenerParams[58].Behavior", "QuestListenerParams[59].Behavior", "QuestListenerParams[60].Behavior", "QuestListenerParams[61].Behavior", "QuestListenerParams[62].Behavior", "QuestListenerParams[63].Behavior", "QuestListenerParams[0].VisibleBool", "QuestListenerParams[1].VisibleBool", "QuestListenerParams[2].VisibleBool", "QuestListenerParams[3].VisibleBool", "QuestListenerParams[4].VisibleBool", "QuestListenerParams[5].VisibleBool", "QuestListenerParams[6].VisibleBool", "QuestListenerParams[7].VisibleBool", "QuestListenerParams[8].VisibleBool", "QuestListenerParams[9].VisibleBool", "QuestListenerParams[10].VisibleBool", "QuestListenerParams[11].VisibleBool", "QuestListenerParams[12].VisibleBool", "QuestListenerParams[13].VisibleBool", "QuestListenerParams[14].VisibleBool", "QuestListenerParams[15].VisibleBool", "QuestListenerParams[16].VisibleBool", "QuestListenerParams[17].VisibleBool", "QuestListenerParams[18].VisibleBool", "QuestListenerParams[19].VisibleBool", "QuestListenerParams[20].VisibleBool", "QuestListenerParams[21].VisibleBool", "QuestListenerParams[22].VisibleBool", "QuestListenerParams[23].VisibleBool", "QuestListenerParams[24].VisibleBool", "QuestListenerParams[25].VisibleBool", "QuestListenerParams[26].VisibleBool", "QuestListenerParams[27].VisibleBool", "QuestListenerParams[28].VisibleBool", "QuestListenerParams[29].VisibleBool", "QuestListenerParams[30].VisibleBool", "QuestListenerParams[31].VisibleBool", "QuestListenerParams[32].VisibleBool", "QuestListenerParams[33].VisibleBool", "QuestListenerParams[34].VisibleBool", "QuestListenerParams[35].VisibleBool", "QuestListenerParams[36].VisibleBool", "QuestListenerParams[37].VisibleBool", "QuestListenerParams[38].VisibleBool", "QuestListenerParams[39].VisibleBool", "QuestListenerParams[40].VisibleBool", "QuestListenerParams[41].VisibleBool", "QuestListenerParams[42].VisibleBool", "QuestListenerParams[43].VisibleBool", "QuestListenerParams[44].VisibleBool", "QuestListenerParams[45].VisibleBool", "QuestListenerParams[46].VisibleBool", "QuestListenerParams[47].VisibleBool", "QuestListenerParams[48].VisibleBool", "QuestListenerParams[49].VisibleBool", "QuestListenerParams[50].VisibleBool", "QuestListenerParams[51].VisibleBool", "QuestListenerParams[52].VisibleBool", "QuestListenerParams[53].VisibleBool", "QuestListenerParams[54].VisibleBool", "QuestListenerParams[55].VisibleBool", "QuestListenerParams[56].VisibleBool", "QuestListenerParams[57].VisibleBool", "QuestListenerParams[58].VisibleBool", "QuestListenerParams[59].VisibleBool", "QuestListenerParams[60].VisibleBool", "QuestListenerParams[61].VisibleBool", "QuestListenerParams[62].VisibleBool", "QuestListenerParams[63].VisibleBool", "QuestListenerParams[0].ConditionBool", "QuestListenerParams[1].ConditionBool", "QuestListenerParams[2].ConditionBool", "QuestListenerParams[3].ConditionBool", "QuestListenerParams[4].ConditionBool", "QuestListenerParams[5].ConditionBool", "QuestListenerParams[6].ConditionBool", "QuestListenerParams[7].ConditionBool", "QuestListenerParams[8].ConditionBool", "QuestListenerParams[9].ConditionBool", "QuestListenerParams[10].ConditionBool", "QuestListenerParams[11].ConditionBool", "QuestListenerParams[12].ConditionBool", "QuestListenerParams[13].ConditionBool", "QuestListenerParams[14].ConditionBool", "QuestListenerParams[15].ConditionBool", "QuestListenerParams[16].ConditionBool", "QuestListenerParams[17].ConditionBool", "QuestListenerParams[18].ConditionBool", "QuestListenerParams[19].ConditionBool", "QuestListenerParams[20].ConditionBool", "QuestListenerParams[21].ConditionBool", "QuestListenerParams[22].ConditionBool", "QuestListenerParams[23].ConditionBool", "QuestListenerParams[24].ConditionBool", "QuestListenerParams[25].ConditionBool", "QuestListenerParams[26].ConditionBool", "QuestListenerParams[27].ConditionBool", "QuestListenerParams[28].ConditionBool", "QuestListenerParams[29].ConditionBool", "QuestListenerParams[30].ConditionBool", "QuestListenerParams[31].ConditionBool", "QuestListenerParams[32].ConditionBool", "QuestListenerParams[33].ConditionBool", "QuestListenerParams[34].ConditionBool", "QuestListenerParams[35].ConditionBool", "QuestListenerParams[36].ConditionBool", "QuestListenerParams[37].ConditionBool", "QuestListenerParams[38].ConditionBool", "QuestListenerParams[39].ConditionBool", "QuestListenerParams[40].ConditionBool", "QuestListenerParams[41].ConditionBool", "QuestListenerParams[42].ConditionBool", "QuestListenerParams[43].ConditionBool", "QuestListenerParams[44].ConditionBool", "QuestListenerParams[45].ConditionBool", "QuestListenerParams[46].ConditionBool", "QuestListenerParams[47].ConditionBool", "QuestListenerParams[48].ConditionBool", "QuestListenerParams[49].ConditionBool", "QuestListenerParams[50].ConditionBool", "QuestListenerParams[51].ConditionBool", "QuestListenerParams[52].ConditionBool", "QuestListenerParams[53].ConditionBool", "QuestListenerParams[54].ConditionBool", "QuestListenerParams[55].ConditionBool", "QuestListenerParams[56].ConditionBool", "QuestListenerParams[57].ConditionBool", "QuestListenerParams[58].ConditionBool", "QuestListenerParams[59].ConditionBool", "QuestListenerParams[60].ConditionBool", "QuestListenerParams[61].ConditionBool", "QuestListenerParams[62].ConditionBool", "QuestListenerParams[63].ConditionBool", "QuestListenerParams[0].ItemBool", "QuestListenerParams[1].ItemBool", "QuestListenerParams[2].ItemBool", "QuestListenerParams[3].ItemBool", "QuestListenerParams[4].ItemBool", "QuestListenerParams[5].ItemBool", "QuestListenerParams[6].ItemBool", "QuestListenerParams[7].ItemBool", "QuestListenerParams[8].ItemBool", "QuestListenerParams[9].ItemBool", "QuestListenerParams[10].ItemBool", "QuestListenerParams[11].ItemBool", "QuestListenerParams[12].ItemBool", "QuestListenerParams[13].ItemBool", "QuestListenerParams[14].ItemBool", "QuestListenerParams[15].ItemBool", "QuestListenerParams[16].ItemBool", "QuestListenerParams[17].ItemBool", "QuestListenerParams[18].ItemBool", "QuestListenerParams[19].ItemBool", "QuestListenerParams[20].ItemBool", "QuestListenerParams[21].ItemBool", "QuestListenerParams[22].ItemBool", "QuestListenerParams[23].ItemBool", "QuestListenerParams[24].ItemBool", "QuestListenerParams[25].ItemBool", "QuestListenerParams[26].ItemBool", "QuestListenerParams[27].ItemBool", "QuestListenerParams[28].ItemBool", "QuestListenerParams[29].ItemBool", "QuestListenerParams[30].ItemBool", "QuestListenerParams[31].ItemBool", "QuestListenerParams[32].ItemBool", "QuestListenerParams[33].ItemBool", "QuestListenerParams[34].ItemBool", "QuestListenerParams[35].ItemBool", "QuestListenerParams[36].ItemBool", "QuestListenerParams[37].ItemBool", "QuestListenerParams[38].ItemBool", "QuestListenerParams[39].ItemBool", "QuestListenerParams[40].ItemBool", "QuestListenerParams[41].ItemBool", "QuestListenerParams[42].ItemBool", "QuestListenerParams[43].ItemBool", "QuestListenerParams[44].ItemBool", "QuestListenerParams[45].ItemBool", "QuestListenerParams[46].ItemBool", "QuestListenerParams[47].ItemBool", "QuestListenerParams[48].ItemBool", "QuestListenerParams[49].ItemBool", "QuestListenerParams[50].ItemBool", "QuestListenerParams[51].ItemBool", "QuestListenerParams[52].ItemBool", "QuestListenerParams[53].ItemBool", "QuestListenerParams[54].ItemBool", "QuestListenerParams[55].ItemBool", "QuestListenerParams[56].ItemBool", "QuestListenerParams[57].ItemBool", "QuestListenerParams[58].ItemBool", "QuestListenerParams[59].ItemBool", "QuestListenerParams[60].ItemBool", "QuestListenerParams[61].ItemBool", "QuestListenerParams[62].ItemBool", "QuestListenerParams[63].ItemBool", "QuestListenerParams[0].AnnounceBool", "QuestListenerParams[1].AnnounceBool", "QuestListenerParams[2].AnnounceBool", "QuestListenerParams[3].AnnounceBool", "QuestListenerParams[4].AnnounceBool", "QuestListenerParams[5].AnnounceBool", "QuestListenerParams[6].AnnounceBool", "QuestListenerParams[7].AnnounceBool", "QuestListenerParams[8].AnnounceBool", "QuestListenerParams[9].AnnounceBool", "QuestListenerParams[10].AnnounceBool", "QuestListenerParams[11].AnnounceBool", "QuestListenerParams[12].AnnounceBool", "QuestListenerParams[13].AnnounceBool", "QuestListenerParams[14].AnnounceBool", "QuestListenerParams[15].AnnounceBool", "QuestListenerParams[16].AnnounceBool", "QuestListenerParams[17].AnnounceBool", "QuestListenerParams[18].AnnounceBool", "QuestListenerParams[19].AnnounceBool", "QuestListenerParams[20].AnnounceBool", "QuestListenerParams[21].AnnounceBool", "QuestListenerParams[22].AnnounceBool", "QuestListenerParams[23].AnnounceBool", "QuestListenerParams[24].AnnounceBool", "QuestListenerParams[25].AnnounceBool", "QuestListenerParams[26].AnnounceBool", "QuestListenerParams[27].AnnounceBool", "QuestListenerParams[28].AnnounceBool", "QuestListenerParams[29].AnnounceBool", "QuestListenerParams[30].AnnounceBool", "QuestListenerParams[31].AnnounceBool", "QuestListenerParams[32].AnnounceBool", "QuestListenerParams[33].AnnounceBool", "QuestListenerParams[34].AnnounceBool", "QuestListenerParams[35].AnnounceBool", "QuestListenerParams[36].AnnounceBool", "QuestListenerParams[37].AnnounceBool", "QuestListenerParams[38].AnnounceBool", "QuestListenerParams[39].AnnounceBool", "QuestListenerParams[40].AnnounceBool", "QuestListenerParams[41].AnnounceBool", "QuestListenerParams[42].AnnounceBool", "QuestListenerParams[43].AnnounceBool", "QuestListenerParams[44].AnnounceBool", "QuestListenerParams[45].AnnounceBool", "QuestListenerParams[46].AnnounceBool", "QuestListenerParams[47].AnnounceBool", "QuestListenerParams[48].AnnounceBool", "QuestListenerParams[49].AnnounceBool", "QuestListenerParams[50].AnnounceBool", "QuestListenerParams[51].AnnounceBool", "QuestListenerParams[52].AnnounceBool", "QuestListenerParams[53].AnnounceBool", "QuestListenerParams[54].AnnounceBool", "QuestListenerParams[55].AnnounceBool", "QuestListenerParams[56].AnnounceBool", "QuestListenerParams[57].AnnounceBool", "QuestListenerParams[58].AnnounceBool", "QuestListenerParams[59].AnnounceBool", "QuestListenerParams[60].AnnounceBool", "QuestListenerParams[61].AnnounceBool", "QuestListenerParams[62].AnnounceBool", "QuestListenerParams[63].AnnounceBool", "QuestListenerParams[0].BehaviorBool", "QuestListenerParams[1].BehaviorBool", "QuestListenerParams[2].BehaviorBool", "QuestListenerParams[3].BehaviorBool", "QuestListenerParams[4].BehaviorBool", "QuestListenerParams[5].BehaviorBool", "QuestListenerParams[6].BehaviorBool", "QuestListenerParams[7].BehaviorBool", "QuestListenerParams[8].BehaviorBool", "QuestListenerParams[9].BehaviorBool", "QuestListenerParams[10].BehaviorBool", "QuestListenerParams[11].BehaviorBool", "QuestListenerParams[12].BehaviorBool", "QuestListenerParams[13].BehaviorBool", "QuestListenerParams[14].BehaviorBool", "QuestListenerParams[15].BehaviorBool", "QuestListenerParams[16].BehaviorBool", "QuestListenerParams[17].BehaviorBool", "QuestListenerParams[18].BehaviorBool", "QuestListenerParams[19].BehaviorBool", "QuestListenerParams[20].BehaviorBool", "QuestListenerParams[21].BehaviorBool", "QuestListenerParams[22].BehaviorBool", "QuestListenerParams[23].BehaviorBool", "QuestListenerParams[24].BehaviorBool", "QuestListenerParams[25].BehaviorBool", "QuestListenerParams[26].BehaviorBool", "QuestListenerParams[27].BehaviorBool", "QuestListenerParams[28].BehaviorBool", "QuestListenerParams[29].BehaviorBool", "QuestListenerParams[30].BehaviorBool", "QuestListenerParams[31].BehaviorBool", "QuestListenerParams[32].BehaviorBool", "QuestListenerParams[33].BehaviorBool", "QuestListenerParams[34].BehaviorBool", "QuestListenerParams[35].BehaviorBool", "QuestListenerParams[36].BehaviorBool", "QuestListenerParams[37].BehaviorBool", "QuestListenerParams[38].BehaviorBool", "QuestListenerParams[39].BehaviorBool", "QuestListenerParams[40].BehaviorBool", "QuestListenerParams[41].BehaviorBool", "QuestListenerParams[42].BehaviorBool", "QuestListenerParams[43].BehaviorBool", "QuestListenerParams[44].BehaviorBool", "QuestListenerParams[45].BehaviorBool", "QuestListenerParams[46].BehaviorBool", "QuestListenerParams[47].BehaviorBool", "QuestListenerParams[48].BehaviorBool", "QuestListenerParams[49].BehaviorBool", "QuestListenerParams[50].BehaviorBool", "QuestListenerParams[51].BehaviorBool", "QuestListenerParams[52].BehaviorBool", "QuestListenerParams[53].BehaviorBool", "QuestListenerParams[54].BehaviorBool", "QuestListenerParams[55].BehaviorBool", "QuestListenerParams[56].BehaviorBool", "QuestListenerParams[57].BehaviorBool", "QuestListenerParams[58].BehaviorBool", "QuestListenerParams[59].BehaviorBool", "QuestListenerParams[60].BehaviorBool", "QuestListenerParams[61].BehaviorBool", "QuestListenerParams[62].BehaviorBool", "QuestListenerParams[63].BehaviorBool", "QuestListenerParams[0].AcceptBool", "QuestListenerParams[1].AcceptBool", "QuestListenerParams[2].AcceptBool", "QuestListenerParams[3].AcceptBool", "QuestListenerParams[4].AcceptBool", "QuestListenerParams[5].AcceptBool", "QuestListenerParams[6].AcceptBool", "QuestListenerParams[7].AcceptBool", "QuestListenerParams[8].AcceptBool", "QuestListenerParams[9].AcceptBool", "QuestListenerParams[10].AcceptBool", "QuestListenerParams[11].AcceptBool", "QuestListenerParams[12].AcceptBool", "QuestListenerParams[13].AcceptBool", "QuestListenerParams[14].AcceptBool", "QuestListenerParams[15].AcceptBool", "QuestListenerParams[16].AcceptBool", "QuestListenerParams[17].AcceptBool", "QuestListenerParams[18].AcceptBool", "QuestListenerParams[19].AcceptBool", "QuestListenerParams[20].AcceptBool", "QuestListenerParams[21].AcceptBool", "QuestListenerParams[22].AcceptBool", "QuestListenerParams[23].AcceptBool", "QuestListenerParams[24].AcceptBool", "QuestListenerParams[25].AcceptBool", "QuestListenerParams[26].AcceptBool", "QuestListenerParams[27].AcceptBool", "QuestListenerParams[28].AcceptBool", "QuestListenerParams[29].AcceptBool", "QuestListenerParams[30].AcceptBool", "QuestListenerParams[31].AcceptBool", "QuestListenerParams[32].AcceptBool", "QuestListenerParams[33].AcceptBool", "QuestListenerParams[34].AcceptBool", "QuestListenerParams[35].AcceptBool", "QuestListenerParams[36].AcceptBool", "QuestListenerParams[37].AcceptBool", "QuestListenerParams[38].AcceptBool", "QuestListenerParams[39].AcceptBool", "QuestListenerParams[40].AcceptBool", "QuestListenerParams[41].AcceptBool", "QuestListenerParams[42].AcceptBool", "QuestListenerParams[43].AcceptBool", "QuestListenerParams[44].AcceptBool", "QuestListenerParams[45].AcceptBool", "QuestListenerParams[46].AcceptBool", "QuestListenerParams[47].AcceptBool", "QuestListenerParams[48].AcceptBool", "QuestListenerParams[49].AcceptBool", "QuestListenerParams[50].AcceptBool", "QuestListenerParams[51].AcceptBool", "QuestListenerParams[52].AcceptBool", "QuestListenerParams[53].AcceptBool", "QuestListenerParams[54].AcceptBool", "QuestListenerParams[55].AcceptBool", "QuestListenerParams[56].AcceptBool", "QuestListenerParams[57].AcceptBool", "QuestListenerParams[58].AcceptBool", "QuestListenerParams[59].AcceptBool", "QuestListenerParams[60].AcceptBool", "QuestListenerParams[61].AcceptBool", "QuestListenerParams[62].AcceptBool", "QuestListenerParams[63].AcceptBool", "QuestListenerParams[0].QualifiedBool", "QuestListenerParams[1].QualifiedBool", "QuestListenerParams[2].QualifiedBool", "QuestListenerParams[3].QualifiedBool", "QuestListenerParams[4].QualifiedBool", "QuestListenerParams[5].QualifiedBool", "QuestListenerParams[6].QualifiedBool", "QuestListenerParams[7].QualifiedBool", "QuestListenerParams[8].QualifiedBool", "QuestListenerParams[9].QualifiedBool", "QuestListenerParams[10].QualifiedBool", "QuestListenerParams[11].QualifiedBool", "QuestListenerParams[12].QualifiedBool", "QuestListenerParams[13].QualifiedBool", "QuestListenerParams[14].QualifiedBool", "QuestListenerParams[15].QualifiedBool", "QuestListenerParams[16].QualifiedBool", "QuestListenerParams[17].QualifiedBool", "QuestListenerParams[18].QualifiedBool", "QuestListenerParams[19].QualifiedBool", "QuestListenerParams[20].QualifiedBool", "QuestListenerParams[21].QualifiedBool", "QuestListenerParams[22].QualifiedBool", "QuestListenerParams[23].QualifiedBool", "QuestListenerParams[24].QualifiedBool", "QuestListenerParams[25].QualifiedBool", "QuestListenerParams[26].QualifiedBool", "QuestListenerParams[27].QualifiedBool", "QuestListenerParams[28].QualifiedBool", "QuestListenerParams[29].QualifiedBool", "QuestListenerParams[30].QualifiedBool", "QuestListenerParams[31].QualifiedBool", "QuestListenerParams[32].QualifiedBool", "QuestListenerParams[33].QualifiedBool", "QuestListenerParams[34].QualifiedBool", "QuestListenerParams[35].QualifiedBool", "QuestListenerParams[36].QualifiedBool", "QuestListenerParams[37].QualifiedBool", "QuestListenerParams[38].QualifiedBool", "QuestListenerParams[39].QualifiedBool", "QuestListenerParams[40].QualifiedBool", "QuestListenerParams[41].QualifiedBool", "QuestListenerParams[42].QualifiedBool", "QuestListenerParams[43].QualifiedBool", "QuestListenerParams[44].QualifiedBool", "QuestListenerParams[45].QualifiedBool", "QuestListenerParams[46].QualifiedBool", "QuestListenerParams[47].QualifiedBool", "QuestListenerParams[48].QualifiedBool", "QuestListenerParams[49].QualifiedBool", "QuestListenerParams[50].QualifiedBool", "QuestListenerParams[51].QualifiedBool", "QuestListenerParams[52].QualifiedBool", "QuestListenerParams[53].QualifiedBool", "QuestListenerParams[54].QualifiedBool", "QuestListenerParams[55].QualifiedBool", "QuestListenerParams[56].QualifiedBool", "QuestListenerParams[57].QualifiedBool", "QuestListenerParams[58].QualifiedBool", "QuestListenerParams[59].QualifiedBool", "QuestListenerParams[60].QualifiedBool", "QuestListenerParams[61].QualifiedBool", "QuestListenerParams[62].QualifiedBool", "QuestListenerParams[63].QualifiedBool", "QuestListenerParams[0].CanTargetBool", "QuestListenerParams[1].CanTargetBool", "QuestListenerParams[2].CanTargetBool", "QuestListenerParams[3].CanTargetBool", "QuestListenerParams[4].CanTargetBool", "QuestListenerParams[5].CanTargetBool", "QuestListenerParams[6].CanTargetBool", "QuestListenerParams[7].CanTargetBool", "QuestListenerParams[8].CanTargetBool", "QuestListenerParams[9].CanTargetBool", "QuestListenerParams[10].CanTargetBool", "QuestListenerParams[11].CanTargetBool", "QuestListenerParams[12].CanTargetBool", "QuestListenerParams[13].CanTargetBool", "QuestListenerParams[14].CanTargetBool", "QuestListenerParams[15].CanTargetBool", "QuestListenerParams[16].CanTargetBool", "QuestListenerParams[17].CanTargetBool", "QuestListenerParams[18].CanTargetBool", "QuestListenerParams[19].CanTargetBool", "QuestListenerParams[20].CanTargetBool", "QuestListenerParams[21].CanTargetBool", "QuestListenerParams[22].CanTargetBool", "QuestListenerParams[23].CanTargetBool", "QuestListenerParams[24].CanTargetBool", "QuestListenerParams[25].CanTargetBool", "QuestListenerParams[26].CanTargetBool", "QuestListenerParams[27].CanTargetBool", "QuestListenerParams[28].CanTargetBool", "QuestListenerParams[29].CanTargetBool", "QuestListenerParams[30].CanTargetBool", "QuestListenerParams[31].CanTargetBool", "QuestListenerParams[32].CanTargetBool", "QuestListenerParams[33].CanTargetBool", "QuestListenerParams[34].CanTargetBool", "QuestListenerParams[35].CanTargetBool", "QuestListenerParams[36].CanTargetBool", "QuestListenerParams[37].CanTargetBool", "QuestListenerParams[38].CanTargetBool", "QuestListenerParams[39].CanTargetBool", "QuestListenerParams[40].CanTargetBool", "QuestListenerParams[41].CanTargetBool", "QuestListenerParams[42].CanTargetBool", "QuestListenerParams[43].CanTargetBool", "QuestListenerParams[44].CanTargetBool", "QuestListenerParams[45].CanTargetBool", "QuestListenerParams[46].CanTargetBool", "QuestListenerParams[47].CanTargetBool", "QuestListenerParams[48].CanTargetBool", "QuestListenerParams[49].CanTargetBool", "QuestListenerParams[50].CanTargetBool", "QuestListenerParams[51].CanTargetBool", "QuestListenerParams[52].CanTargetBool", "QuestListenerParams[53].CanTargetBool", "QuestListenerParams[54].CanTargetBool", "QuestListenerParams[55].CanTargetBool", "QuestListenerParams[56].CanTargetBool", "QuestListenerParams[57].CanTargetBool", "QuestListenerParams[58].CanTargetBool", "QuestListenerParams[59].CanTargetBool", "QuestListenerParams[60].CanTargetBool", "QuestListenerParams[61].CanTargetBool", "QuestListenerParams[62].CanTargetBool", "QuestListenerParams[63].CanTargetBool", "TodoParams[0].ToDoCompleteSeq", "TodoParams[1].ToDoCompleteSeq", "TodoParams[2].ToDoCompleteSeq", "TodoParams[3].ToDoCompleteSeq", "TodoParams[4].ToDoCompleteSeq", "TodoParams[5].ToDoCompleteSeq", "TodoParams[6].ToDoCompleteSeq", "TodoParams[7].ToDoCompleteSeq", "TodoParams[8].ToDoCompleteSeq", "TodoParams[9].ToDoCompleteSeq", "TodoParams[10].ToDoCompleteSeq", "TodoParams[11].ToDoCompleteSeq", "TodoParams[12].ToDoCompleteSeq", "TodoParams[13].ToDoCompleteSeq", "TodoParams[14].ToDoCompleteSeq", "TodoParams[15].ToDoCompleteSeq", "TodoParams[16].ToDoCompleteSeq", "TodoParams[17].ToDoCompleteSeq", "TodoParams[18].ToDoCompleteSeq", "TodoParams[19].ToDoCompleteSeq", "TodoParams[20].ToDoCompleteSeq", "TodoParams[21].ToDoCompleteSeq", "TodoParams[22].ToDoCompleteSeq", "TodoParams[23].ToDoCompleteSeq", "TodoParams[0].ToDoQty", "TodoParams[1].ToDoQty", "TodoParams[2].ToDoQty", "TodoParams[3].ToDoQty", "TodoParams[4].ToDoQty", "TodoParams[5].ToDoQty", "TodoParams[6].ToDoQty", "TodoParams[7].ToDoQty", "TodoParams[8].ToDoQty", "TodoParams[9].ToDoQty", "TodoParams[10].ToDoQty", "TodoParams[11].ToDoQty", "TodoParams[12].ToDoQty", "TodoParams[13].ToDoQty", "TodoParams[14].ToDoQty", "TodoParams[15].ToDoQty", "TodoParams[16].ToDoQty", "TodoParams[17].ToDoQty", "TodoParams[18].ToDoQty", "TodoParams[19].ToDoQty", "TodoParams[20].ToDoQty", "TodoParams[21].ToDoQty", "TodoParams[22].ToDoQty", "TodoParams[23].ToDoQty", "TodoParams[0].ToDoLocation[0]", "TodoParams[1].ToDoLocation[0]", "TodoParams[2].ToDoLocation[0]", "TodoParams[3].ToDoLocation[0]", "TodoParams[4].ToDoLocation[0]", "TodoParams[5].ToDoLocation[0]", "TodoParams[6].ToDoLocation[0]", "TodoParams[7].ToDoLocation[0]", "TodoParams[8].ToDoLocation[0]", "TodoParams[9].ToDoLocation[0]", "TodoParams[10].ToDoLocation[0]", "TodoParams[11].ToDoLocation[0]", "TodoParams[12].ToDoLocation[0]", "TodoParams[13].ToDoLocation[0]", "TodoParams[14].ToDoLocation[0]", "TodoParams[15].ToDoLocation[0]", "TodoParams[16].ToDoLocation[0]", "TodoParams[17].ToDoLocation[0]", "TodoParams[18].ToDoLocation[0]", "TodoParams[19].ToDoLocation[0]", "TodoParams[20].ToDoLocation[0]", "TodoParams[21].ToDoLocation[0]", "TodoParams[22].ToDoLocation[0]", "TodoParams[23].ToDoLocation[0]", "TodoParams[0].ToDoLocation[1]", "TodoParams[1].ToDoLocation[1]", "TodoParams[2].ToDoLocation[1]", "TodoParams[3].ToDoLocation[1]", "TodoParams[4].ToDoLocation[1]", "TodoParams[5].ToDoLocation[1]", "TodoParams[6].ToDoLocation[1]", "TodoParams[7].ToDoLocation[1]", "TodoParams[8].ToDoLocation[1]", "TodoParams[9].ToDoLocation[1]", "TodoParams[10].ToDoLocation[1]", "TodoParams[11].ToDoLocation[1]", "TodoParams[12].ToDoLocation[1]", "TodoParams[13].ToDoLocation[1]", "TodoParams[14].ToDoLocation[1]", "TodoParams[15].ToDoLocation[1]", "TodoParams[16].ToDoLocation[1]", "TodoParams[17].ToDoLocation[1]", "TodoParams[18].ToDoLocation[1]", "TodoParams[19].ToDoLocation[1]", "TodoParams[20].ToDoLocation[1]", "TodoParams[21].ToDoLocation[1]", "TodoParams[22].ToDoLocation[1]", "TodoParams[23].ToDoLocation[1]", "TodoParams[0].ToDoLocation[2]", "TodoParams[1].ToDoLocation[2]", "TodoParams[2].ToDoLocation[2]", "TodoParams[3].ToDoLocation[2]", "TodoParams[4].ToDoLocation[2]", "TodoParams[5].ToDoLocation[2]", "TodoParams[6].ToDoLocation[2]", "TodoParams[7].ToDoLocation[2]", "TodoParams[8].ToDoLocation[2]", "TodoParams[9].ToDoLocation[2]", "TodoParams[10].ToDoLocation[2]", "TodoParams[11].ToDoLocation[2]", "TodoParams[12].ToDoLocation[2]", "TodoParams[13].ToDoLocation[2]", "TodoParams[14].ToDoLocation[2]", "TodoParams[15].ToDoLocation[2]", "TodoParams[16].ToDoLocation[2]", "TodoParams[17].ToDoLocation[2]", "TodoParams[18].ToDoLocation[2]", "TodoParams[19].ToDoLocation[2]", "TodoParams[20].ToDoLocation[2]", "TodoParams[21].ToDoLocation[2]", "TodoParams[22].ToDoLocation[2]", "TodoParams[23].ToDoLocation[2]", "TodoParams[0].ToDoLocation[3]", "TodoParams[1].ToDoLocation[3]", "TodoParams[2].ToDoLocation[3]", "TodoParams[3].ToDoLocation[3]", "TodoParams[4].ToDoLocation[3]", "TodoParams[5].ToDoLocation[3]", "TodoParams[6].ToDoLocation[3]", "TodoParams[7].ToDoLocation[3]", "TodoParams[8].ToDoLocation[3]", "TodoParams[9].ToDoLocation[3]", "TodoParams[10].ToDoLocation[3]", "TodoParams[11].ToDoLocation[3]", "TodoParams[12].ToDoLocation[3]", "TodoParams[13].ToDoLocation[3]", "TodoParams[14].ToDoLocation[3]", "TodoParams[15].ToDoLocation[3]", "TodoParams[16].ToDoLocation[3]", "TodoParams[17].ToDoLocation[3]", "TodoParams[18].ToDoLocation[3]", "TodoParams[19].ToDoLocation[3]", "TodoParams[20].ToDoLocation[3]", "TodoParams[21].ToDoLocation[3]", "TodoParams[22].ToDoLocation[3]", "TodoParams[23].ToDoLocation[3]", "TodoParams[0].ToDoLocation[4]", "TodoParams[1].ToDoLocation[4]", "TodoParams[2].ToDoLocation[4]", "TodoParams[3].ToDoLocation[4]", "TodoParams[4].ToDoLocation[4]", "TodoParams[5].ToDoLocation[4]", "TodoParams[6].ToDoLocation[4]", "TodoParams[7].ToDoLocation[4]", "TodoParams[8].ToDoLocation[4]", "TodoParams[9].ToDoLocation[4]", "TodoParams[10].ToDoLocation[4]", "TodoParams[11].ToDoLocation[4]", "TodoParams[12].ToDoLocation[4]", "TodoParams[13].ToDoLocation[4]", "TodoParams[14].ToDoLocation[4]", "TodoParams[15].ToDoLocation[4]", "TodoParams[16].ToDoLocation[4]", "TodoParams[17].ToDoLocation[4]", "TodoParams[18].ToDoLocation[4]", "TodoParams[19].ToDoLocation[4]", "TodoParams[20].ToDoLocation[4]", "TodoParams[21].ToDoLocation[4]", "TodoParams[22].ToDoLocation[4]", "TodoParams[23].ToDoLocation[4]", "TodoParams[0].ToDoLocation[5]", "TodoParams[1].ToDoLocation[5]", "TodoParams[2].ToDoLocation[5]", "TodoParams[3].ToDoLocation[5]", "TodoParams[4].ToDoLocation[5]", "TodoParams[5].ToDoLocation[5]", "TodoParams[6].ToDoLocation[5]", "TodoParams[7].ToDoLocation[5]", "TodoParams[8].ToDoLocation[5]", "TodoParams[9].ToDoLocation[5]", "TodoParams[10].ToDoLocation[5]", "TodoParams[11].ToDoLocation[5]", "TodoParams[12].ToDoLocation[5]", "TodoParams[13].ToDoLocation[5]", "TodoParams[14].ToDoLocation[5]", "TodoParams[15].ToDoLocation[5]", "TodoParams[16].ToDoLocation[5]", "TodoParams[17].ToDoLocation[5]", "TodoParams[18].ToDoLocation[5]", "TodoParams[19].ToDoLocation[5]", "TodoParams[20].ToDoLocation[5]", "TodoParams[21].ToDoLocation[5]", "TodoParams[22].ToDoLocation[5]", "TodoParams[23].ToDoLocation[5]", "TodoParams[0].ToDoLocation[6]", "TodoParams[1].ToDoLocation[6]", "TodoParams[2].ToDoLocation[6]", "TodoParams[3].ToDoLocation[6]", "TodoParams[4].ToDoLocation[6]", "TodoParams[5].ToDoLocation[6]", "TodoParams[6].ToDoLocation[6]", "TodoParams[7].ToDoLocation[6]", "TodoParams[8].ToDoLocation[6]", "TodoParams[9].ToDoLocation[6]", "TodoParams[10].ToDoLocation[6]", "TodoParams[11].ToDoLocation[6]", "TodoParams[12].ToDoLocation[6]", "TodoParams[13].ToDoLocation[6]", "TodoParams[14].ToDoLocation[6]", "TodoParams[15].ToDoLocation[6]", "TodoParams[16].ToDoLocation[6]", "TodoParams[17].ToDoLocation[6]", "TodoParams[18].ToDoLocation[6]", "TodoParams[19].ToDoLocation[6]", "TodoParams[20].ToDoLocation[6]", "TodoParams[21].ToDoLocation[6]", "TodoParams[22].ToDoLocation[6]", "TodoParams[23].ToDoLocation[6]", "TodoParams[0].ToDoLocation[7]", "TodoParams[1].ToDoLocation[7]", "TodoParams[2].ToDoLocation[7]", "TodoParams[3].ToDoLocation[7]", "TodoParams[4].ToDoLocation[7]", "TodoParams[5].ToDoLocation[7]", "TodoParams[6].ToDoLocation[7]", "TodoParams[7].ToDoLocation[7]", "TodoParams[8].ToDoLocation[7]", "TodoParams[9].ToDoLocation[7]", "TodoParams[10].ToDoLocation[7]", "TodoParams[11].ToDoLocation[7]", "TodoParams[12].ToDoLocation[7]", "TodoParams[13].ToDoLocation[7]", "TodoParams[14].ToDoLocation[7]", "TodoParams[15].ToDoLocation[7]", "TodoParams[16].ToDoLocation[7]", "TodoParams[17].ToDoLocation[7]", "TodoParams[18].ToDoLocation[7]", "TodoParams[19].ToDoLocation[7]", "TodoParams[20].ToDoLocation[7]", "TodoParams[21].ToDoLocation[7]", "TodoParams[22].ToDoLocation[7]", "TodoParams[23].ToDoLocation[7]", "TodoParams[0].CountableNum", "TodoParams[1].CountableNum", "TodoParams[2].CountableNum", "TodoParams[3].CountableNum", "TodoParams[4].CountableNum", "TodoParams[5].CountableNum", "TodoParams[6].CountableNum", "TodoParams[7].CountableNum", "TodoParams[8].CountableNum", "TodoParams[9].CountableNum", "TodoParams[10].CountableNum", "TodoParams[11].CountableNum", "TodoParams[12].CountableNum", "TodoParams[13].CountableNum", "TodoParams[14].CountableNum", "TodoParams[15].CountableNum", "TodoParams[16].CountableNum", "TodoParams[17].CountableNum", "TodoParams[18].CountableNum", "TodoParams[19].CountableNum", "TodoParams[20].CountableNum", "TodoParams[21].CountableNum", "TodoParams[22].CountableNum", "TodoParams[23].CountableNum", "LevelMax", "ClassJobRequired", "QuestRewardOtherDisplay", "ExpFactor", "GilReward", "CurrencyReward", "CurrencyRewardCount", "ItemCatalyst[0]", "ItemCatalyst[1]", "ItemCatalyst[2]", "ItemCountCatalyst[0]", "ItemCountCatalyst[1]", "ItemCountCatalyst[2]", "ItemRewardType", "Reward[0]", "Reward[1]", "Reward[2]", "Reward[3]", "Reward[4]", "Reward[5]", "Reward[6]", "ItemCountReward[0]", "ItemCountReward[1]", "ItemCountReward[2]", "ItemCountReward[3]", "ItemCountReward[4]", "ItemCountReward[5]", "ItemCountReward[6]", "Unknown0", "Unknown1", "Unknown2", "Unknown3", "Unknown4", "Unknown5", "Unknown6", "RewardStain[0]", "RewardStain[1]", "RewardStain[2]", "RewardStain[3]", "RewardStain[4]", "RewardStain[5]", "RewardStain[6]", "OptionalItemReward[0]", "OptionalItemReward[1]", "OptionalItemReward[2]", "OptionalItemReward[3]", "OptionalItemReward[4]", "OptionalItemCountReward[0]", "OptionalItemCountReward[1]", "OptionalItemCountReward[2]", "OptionalItemCountReward[3]", "OptionalItemCountReward[4]", "OptionalItemIsHQReward[0]", "OptionalItemIsHQReward[1]", "OptionalItemIsHQReward[2]", "OptionalItemIsHQReward[3]", "OptionalItemIsHQReward[4]", "OptionalItemStainReward[0]", "OptionalItemStainReward[1]", "OptionalItemStainReward[2]", "OptionalItemStainReward[3]", "OptionalItemStainReward[4]", "EmoteReward", "ActionReward", "GeneralActionReward[0]", "GeneralActionReward[1]", "SystemReward[0]", "OtherReward", "SystemReward[1]", "GCTypeReward", "InstanceContentUnlock", "Tomestone", "TomestoneReward", "TomestoneCountReward", "ReputationReward", "PlaceName", "JournalGenre", "Unknown10", "Icon", "IconSpecial", "Introduction", "HideOfferIcon", "EventIconType", "DailyQuestPool", "SortKey", "Unknown12", "HideInScenarioGuide" };

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
