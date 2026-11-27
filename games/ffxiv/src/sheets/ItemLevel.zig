//! `ItemLevel`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ItemLevel = @This();

pub const sheet_name = "ItemLevel";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe216399f;
pub const Sheet = excel.Typed(ItemLevel);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Strength", "Dexterity", "Vitality", "Intelligence", "Mind", "Piety", "HP", "MP", "TP", "GP", "CP", "PhysicalDamage", "MagicalDamage", "Delay", "AdditionalEffect", "AttackSpeed", "BlockRate", "BlockStrength", "Tenacity", "AttackPower", "Defense", "DirectHitRate", "Evasion", "MagicDefense", "CriticalHitPower", "CriticalHitResilience", "CriticalHit", "CriticalHitEvasion", "SlashingResistance", "PiercingResistance", "BluntResistance", "ProjectileResistance", "AttackMagicPotency", "HealingMagicPotency", "EnhancementMagicPotency", "EnfeeblingMagicPotency", "FireResistance", "IceResistance", "WindResistance", "EarthResistance", "LightningResistance", "WaterResistance", "MagicResistance", "Determination", "SkillSpeed", "SpellSpeed", "Haste", "Morale", "Enmity", "EnmityReduction", "CarefulDesynthesis", "EXPBonus", "Regen", "Refresh", "MovementSpeed", "Spikes", "SlowResistance", "PetrificationResistance", "ParalysisResistance", "SilenceResistance", "BlindResistance", "PoisonResistance", "StunResistance", "SleepResistance", "BindResistance", "HeavyResistance", "DoomResistance", "ReducedDurabilityLoss", "IncreasedSpiritbondGain", "Craftsmanship", "Control", "Gathering", "Perception", "Unknown0" };

pub fn strength(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn dexterity(self: @This()) u16 {
    return self.row.at(u16, 2);
}

pub fn vitality(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn intelligence(self: @This()) u16 {
    return self.row.at(u16, 6);
}

pub fn mind(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn piety(self: @This()) u16 {
    return self.row.at(u16, 10);
}

pub fn hp(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn mp(self: @This()) u16 {
    return self.row.at(u16, 14);
}

pub fn tp(self: @This()) u16 {
    return self.row.at(u16, 16);
}

pub fn gp(self: @This()) u16 {
    return self.row.at(u16, 18);
}

pub fn cp(self: @This()) u16 {
    return self.row.at(u16, 20);
}

pub fn physicalDamage(self: @This()) u16 {
    return self.row.at(u16, 22);
}

pub fn magicalDamage(self: @This()) u16 {
    return self.row.at(u16, 24);
}

pub fn delay(self: @This()) u16 {
    return self.row.at(u16, 26);
}

pub fn additionalEffect(self: @This()) u16 {
    return self.row.at(u16, 28);
}

pub fn attackSpeed(self: @This()) u16 {
    return self.row.at(u16, 30);
}

pub fn blockRate(self: @This()) u16 {
    return self.row.at(u16, 32);
}

pub fn blockStrength(self: @This()) u16 {
    return self.row.at(u16, 34);
}

pub fn tenacity(self: @This()) u16 {
    return self.row.at(u16, 36);
}

pub fn attackPower(self: @This()) u16 {
    return self.row.at(u16, 38);
}

pub fn defense(self: @This()) u16 {
    return self.row.at(u16, 40);
}

pub fn directHitRate(self: @This()) u16 {
    return self.row.at(u16, 42);
}

pub fn evasion(self: @This()) u16 {
    return self.row.at(u16, 44);
}

pub fn magicDefense(self: @This()) u16 {
    return self.row.at(u16, 46);
}

pub fn criticalHitPower(self: @This()) u16 {
    return self.row.at(u16, 48);
}

pub fn criticalHitResilience(self: @This()) u16 {
    return self.row.at(u16, 50);
}

pub fn criticalHit(self: @This()) u16 {
    return self.row.at(u16, 52);
}

pub fn criticalHitEvasion(self: @This()) u16 {
    return self.row.at(u16, 54);
}

pub fn slashingResistance(self: @This()) u16 {
    return self.row.at(u16, 56);
}

pub fn piercingResistance(self: @This()) u16 {
    return self.row.at(u16, 58);
}

pub fn bluntResistance(self: @This()) u16 {
    return self.row.at(u16, 60);
}

pub fn projectileResistance(self: @This()) u16 {
    return self.row.at(u16, 62);
}

pub fn attackMagicPotency(self: @This()) u16 {
    return self.row.at(u16, 64);
}

pub fn healingMagicPotency(self: @This()) u16 {
    return self.row.at(u16, 66);
}

pub fn enhancementMagicPotency(self: @This()) u16 {
    return self.row.at(u16, 68);
}

pub fn enfeeblingMagicPotency(self: @This()) u16 {
    return self.row.at(u16, 70);
}

pub fn fireResistance(self: @This()) u16 {
    return self.row.at(u16, 72);
}

pub fn iceResistance(self: @This()) u16 {
    return self.row.at(u16, 74);
}

pub fn windResistance(self: @This()) u16 {
    return self.row.at(u16, 76);
}

pub fn earthResistance(self: @This()) u16 {
    return self.row.at(u16, 78);
}

pub fn lightningResistance(self: @This()) u16 {
    return self.row.at(u16, 80);
}

pub fn waterResistance(self: @This()) u16 {
    return self.row.at(u16, 82);
}

pub fn magicResistance(self: @This()) u16 {
    return self.row.at(u16, 84);
}

pub fn determination(self: @This()) u16 {
    return self.row.at(u16, 86);
}

pub fn skillSpeed(self: @This()) u16 {
    return self.row.at(u16, 88);
}

pub fn spellSpeed(self: @This()) u16 {
    return self.row.at(u16, 90);
}

pub fn haste(self: @This()) u16 {
    return self.row.at(u16, 92);
}

pub fn morale(self: @This()) u16 {
    return self.row.at(u16, 94);
}

pub fn enmity(self: @This()) u16 {
    return self.row.at(u16, 96);
}

pub fn enmityReduction(self: @This()) u16 {
    return self.row.at(u16, 98);
}

pub fn carefulDesynthesis(self: @This()) u16 {
    return self.row.at(u16, 100);
}

pub fn expBonus(self: @This()) u16 {
    return self.row.at(u16, 102);
}

pub fn regen(self: @This()) u16 {
    return self.row.at(u16, 104);
}

pub fn refresh(self: @This()) u16 {
    return self.row.at(u16, 106);
}

pub fn movementSpeed(self: @This()) u16 {
    return self.row.at(u16, 108);
}

pub fn spikes(self: @This()) u16 {
    return self.row.at(u16, 110);
}

pub fn slowResistance(self: @This()) u16 {
    return self.row.at(u16, 112);
}

pub fn petrificationResistance(self: @This()) u16 {
    return self.row.at(u16, 114);
}

pub fn paralysisResistance(self: @This()) u16 {
    return self.row.at(u16, 116);
}

pub fn silenceResistance(self: @This()) u16 {
    return self.row.at(u16, 118);
}

pub fn blindResistance(self: @This()) u16 {
    return self.row.at(u16, 120);
}

pub fn poisonResistance(self: @This()) u16 {
    return self.row.at(u16, 122);
}

pub fn stunResistance(self: @This()) u16 {
    return self.row.at(u16, 124);
}

pub fn sleepResistance(self: @This()) u16 {
    return self.row.at(u16, 126);
}

pub fn bindResistance(self: @This()) u16 {
    return self.row.at(u16, 128);
}

pub fn heavyResistance(self: @This()) u16 {
    return self.row.at(u16, 130);
}

pub fn doomResistance(self: @This()) u16 {
    return self.row.at(u16, 132);
}

pub fn reducedDurabilityLoss(self: @This()) u16 {
    return self.row.at(u16, 134);
}

pub fn increasedSpiritbondGain(self: @This()) u16 {
    return self.row.at(u16, 136);
}

pub fn craftsmanship(self: @This()) u16 {
    return self.row.at(u16, 138);
}

pub fn control(self: @This()) u16 {
    return self.row.at(u16, 140);
}

pub fn gathering(self: @This()) u16 {
    return self.row.at(u16, 142);
}

pub fn perception(self: @This()) u16 {
    return self.row.at(u16, 144);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 146);
}
