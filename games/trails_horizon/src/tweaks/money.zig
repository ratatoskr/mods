//! Money tweaks: free shopping and giving Mira.

const std = @import("std");
const sdk = @import("wraith_sdk");
const schema = @import("schema").TrailsHorizon;
const common = @import("common.zig");

const W = sdk.api.wraith;
const Atomic = sdk.atomic.Value;
const sections = common.sections;

const GameStateManager = schema.GameStateManager;

pub const Mira = struct {
    const SpendHook = sdk.hooks.Hook(GameStateManager, .spendMira);

    const GiveMira = struct {
        amount: u32 = 10000,
        pub const fields = .{ .amount = .{ .min = 1 } };
    };

    spend_mira: SpendHook = undefined,

    pub fn start(self: *Mira, ctx: *sdk.Context) !void {
        self.spend_mira = try sdk.hooks.hook(GameStateManager, .spendMira, spendMiraDetour, self);
        try sdk.tweaks.hook(ctx, .{ .id = "free_shopping", .title = "Free shopping", .section = sections.money }, &self.spend_mira);

        try sdk.tweaks.action(ctx, .{ .id = "give_mira", .title = "Give Mira", .section = sections.money }, GiveMira, self, giveMira);
    }

    fn spendMiraDetour(_: *Mira, hook: SpendHook, manager: *GameStateManager, _: u32) u32 {
        return hook.original()(manager, 0);
    }

    fn giveMira(_: *Mira, args: GiveMira) !void {
        _ = (try GameStateManager.instanceOrFail()).giveMira(args.amount);
    }
};
