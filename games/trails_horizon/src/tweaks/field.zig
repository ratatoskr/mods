//! Field tweaks: enemies that don't notice you, tailing without being seen, and FIO's lasers.

const std = @import("std");
const sdk = @import("wraith_sdk");
const schema = @import("schema");
const common = @import("common.zig");

const sections = common.sections;

const FieldSymbol = schema.FieldSymbol;
const FioSneaking = schema.FioSneaking;

pub const Field = struct {
    const Update = FieldSymbol.Fns.update;
    const UpdateHook = sdk.hooks.FnHook(Update);
    const LaserHit = FioSneaking.Fns.laserHit;
    const LaserHook = sdk.hooks.FnHook(LaserHit);

    const noticed = 2;
    const wary = 1;

    update: UpdateHook = undefined,
    laser: LaserHook = undefined,

    pub fn start(self: *Field, ctx: *sdk.Context) !void {
        self.update = try sdk.hooks.createFn(Update, try FieldSymbol.addresses.update(), updateDetour, self);
        try sdk.tweaks.hook(ctx, .{ .id = "stealth", .title = "Enemies don't notice you", .section = sections.field }, &self.update);

        const text = try sdk.Module.main().text();
        // The tail's flag for being seen goes up only past the gauge, and the gauge doesn't fill
        try common.patchTweak(ctx, .{ .id = "tailing_stealth", .title = "Tailing without being seen", .section = sections.field }, &.{
            .{ .at = text.scan("tailing: seen", "76 ?? 48 C7 87 ?? ?? ?? ?? ?? ?? ?? ?? 41 0F 28 F2"), .bytes = &.{0xEB}, .expect = "76" },
            .{ .at = text.scan("tailing: gauge", "F3 0F 5F FE 0F 28 B4 24 ?? ?? ?? ?? F3 0F 11 BF"), .bytes = &.{ 0xEB, 0x02 }, .expect = "F3 0F 5F FE" },
        });

        self.laser = try sdk.hooks.createFn(LaserHit, try FioSneaking.addresses.laserHit(), laserDetour, self);
        try sdk.tweaks.hook(ctx, .{ .id = "fio_lasers", .title = "FIO's lasers don't see her", .section = sections.field }, &self.laser);
    }

    /// Takes back noticing the party, which it does at the end.
    fn updateDetour(_: *Field, hook: UpdateHook, symbol: *FieldSymbol) void {
        const before = senseOf(symbol);
        const was = if (before) |s| s.state else 0;
        hook.original()(symbol);
        const after = senseOf(symbol) orelse return;
        if (after.state == noticed and (after != before or was != noticed)) after.state = wary;
    }

    fn senseOf(symbol: *FieldSymbol) ?*schema.SymbolSense {
        const i = symbol.sense;
        if (i < 0 or i >= symbol.senses.len) return null;
        return &symbol.senses[@intCast(i)];
    }

    fn laserDetour(_: *Field, _: LaserHook, _: *FioSneaking) void {}
};
