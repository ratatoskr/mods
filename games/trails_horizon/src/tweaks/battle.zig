//! Combat tweaks: one-hit kills, no damage, can't die and restoring the party.

const std = @import("std");
const sdk = @import("wraith_sdk");
const schema = @import("schema").TrailsHorizon;
const common = @import("common.zig");

const W = sdk.api.wraith;
const Atomic = sdk.atomic.Value;
const sections = common.sections;

const GameStateManager = schema.GameStateManager;
const Status = schema.Status;

pub const Battle = struct {
    const ChangeHook = sdk.hooks.Hook(Status, .change);

    /// `Status.change` adding to HP
    const add_hp = 8;
    const party = 1;

    change: ChangeHook = undefined,
    one_hit: Atomic(bool) = .init(false),
    no_damage: Atomic(bool) = .init(false),
    no_dying: Atomic(bool) = .init(false),

    pub fn start(self: *Battle, ctx: *sdk.Context) !void {
        self.change = try sdk.hooks.hook(Status, .change, changeDetour, self);
        try sdk.tweaks.toggle(ctx, .{ .id = "one_hit_kills", .title = "One-hit kills", .section = sections.combat }, struct {}, self, Flag("one_hit"));
        try sdk.tweaks.toggle(ctx, .{ .id = "no_damage", .title = "Party takes no damage", .section = sections.combat }, struct {}, self, Flag("no_damage"));
        try sdk.tweaks.toggle(ctx, .{ .id = "cant_die", .title = "Party can't die", .section = sections.combat }, struct {}, self, Flag("no_dying"));
        try sdk.tweaks.action(ctx, .{ .id = "restore", .title = "Restore HP, EP and CP", .section = sections.combat }, struct {}, self, restore);
    }

    fn Flag(comptime name: []const u8) type {
        return struct {
            pub fn on(b: *Battle, _: anytype) !void {
                @field(b, name).store(true, .release);
                try b.syncChange();
            }
            pub fn off(b: *Battle) void {
                @field(b, name).store(false, .release);
                b.syncChange() catch {};
            }
        };
    }

    fn syncChange(self: *Battle) !void {
        try common.sync(&self.change, self.one_hit.load(.acquire) or self.no_damage.load(.acquire) or self.no_dying.load(.acquire));
    }

    fn changeDetour(self: *Battle, hook: ChangeHook, status: *Status, kind: u32, value: i32) void {
        var v = value;
        if (kind == add_hp and v < 0) {
            if (status.side == party) {
                if (self.no_damage.load(.acquire)) v = 0;
                // Down to 1, but no further
                if (self.no_dying.load(.acquire) and @as(i64, status.hp) + v < 1) v = @min(0, 1 - status.hp);
            } else if (self.one_hit.load(.acquire)) v = -9_999_999;
        }
        hook.original()(status, kind, v);
    }

    fn restore(_: *Battle, _: anytype) !void {
        const manager = try GameStateManager.instanceOrFail();
        for (&manager.roster) |*s| {
            if (s.max_hp <= 0) continue;
            s.hp = s.max_hp;
            s.ep = s.max_ep;
            s.cp = s.max_cp;
        }
    }
};
