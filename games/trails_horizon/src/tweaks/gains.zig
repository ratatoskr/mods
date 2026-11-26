//! Experience and gourmet points, times a number.

const std = @import("std");
const sdk = @import("wraith_sdk");
const schema = @import("schema").TrailsHorizon;
const common = @import("common.zig");

const W = sdk.api.wraith;
const Atomic = sdk.atomic.Value;
const sections = common.sections;

const GameStateManager = schema.GameStateManager;
const ResultMenu = schema.ResultMenu;

pub const Gains = struct {
    const ExpHook = sdk.hooks.Hook(ResultMenu, .calcGetExp);
    const HoloHook = sdk.hooks.Hook(ResultMenu, .calcGetHollowCoreExp);
    const RecipeHook = sdk.hooks.Hook(GameStateManager, .learnRecipe);

    const Times = struct {
        times: u32 = 10,
        pub const fields = .{ .times = .{ .min = 1, .max = 1000, .label = "Times" } };
    };
    const Twice = struct {
        times: u32 = 2,
        pub const fields = .{ .times = .{ .min = 1, .max = 1000, .label = "Times" } };
    };

    exp: ExpHook = undefined,
    holo: HoloHook = undefined,
    recipe: RecipeHook = undefined,
    exp_times: Atomic(u32) = .init(1),
    holo_times: Atomic(u32) = .init(1),
    recipe_times: Atomic(u32) = .init(1),

    pub fn start(self: *Gains, ctx: *sdk.Context) !void {
        self.exp = try sdk.hooks.hook(ResultMenu, .calcGetExp, expDetour, self);
        self.holo = try sdk.hooks.hook(ResultMenu, .calcGetHollowCoreExp, holoDetour, self);
        self.recipe = try sdk.hooks.hook(GameStateManager, .learnRecipe, recipeDetour, self);
        try sdk.tweaks.toggle(ctx, .{ .id = "exp_times", .title = "More experience", .section = sections.exp }, Times, self, Multiplier("exp", "exp_times"));
        try sdk.tweaks.toggle(ctx, .{ .id = "holo_exp_times", .title = "More hollow core experience", .section = sections.exp }, Times, self, Multiplier("holo", "holo_times"));
        try sdk.tweaks.toggle(ctx, .{ .id = "gourmet_times", .title = "More gourmet points", .section = sections.exp }, Twice, self, Multiplier("recipe", "recipe_times"));
    }

    /// Callbacks for a toggle that sets `times` and turns `hook` on.
    fn Multiplier(comptime hook: []const u8, comptime value: []const u8) type {
        return struct {
            pub fn on(g: *Gains, args: anytype) !void {
                @field(g, value).store(args.times, .release);
                try @field(g, hook).enable();
            }
            pub fn changed(g: *Gains, args: anytype) !void {
                @field(g, value).store(args.times, .release);
            }
            pub fn off(g: *Gains) void {
                @field(g, hook).disable() catch {};
            }
        };
    }

    fn expDetour(self: *Gains, hook: ExpHook, menu: *ResultMenu, chara: usize, label: usize) i32 {
        return common.times(hook.original()(menu, chara, label), self.exp_times.load(.acquire));
    }

    fn holoDetour(self: *Gains, hook: HoloHook, menu: *ResultMenu, chara: usize) i32 {
        return common.times(hook.original()(menu, chara), self.holo_times.load(.acquire));
    }

    fn recipeDetour(self: *Gains, hook: RecipeHook, manager: *GameStateManager, recipe: u32) bool {
        const before = manager.gourmet_points;
        const learned = hook.original()(manager, recipe);
        if (learned and manager.gourmet_points > before) {
            const got = manager.gourmet_points - before;
            manager.gourmet_points = before +| got *| self.recipe_times.load(.acquire);
        }
        return learned;
    }
};
