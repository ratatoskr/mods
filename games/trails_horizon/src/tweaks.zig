//! The plugin's tweaks, in the overlay's Tweaks menu.

const std = @import("std");
const sdk = @import("wraith_sdk");
const schema = @import("schema");

const W = sdk.api.wraith;

const GameStateManager = schema.GameStateManager;

pub const Mira = struct {
    const SpendMira = GameStateManager.Fns.spendMira;
    const SpendHook = sdk.hooks.FnHook(SpendMira);

    const GiveMira = struct {
        amount: u32 = 10000,
        pub const fields = .{ .amount = .{ .min = 1 } };
    };

    spend_mira: SpendHook = undefined,

    pub fn start(self: *Mira, ctx: *sdk.Context) !void {
        self.spend_mira = try sdk.hooks.createFn(SpendMira, try GameStateManager.addresses.spendMira(), spendMiraDetour, self);
        try sdk.tweaks.hook(ctx, .{ .id = "free_shopping", .title = "Free shopping" }, &self.spend_mira);

        try sdk.tweaks.action(ctx, .{ .id = "give_mira", .title = "Give Mira" }, GiveMira, self, giveMira);
    }

    fn spendMiraDetour(_: *Mira, hook: SpendHook, manager: *GameStateManager, _: u32) u32 {
        return hook.original()(manager, 0);
    }

    fn giveMira(_: *Mira, args: GiveMira) !void {
        _ = (try GameStateManager.instanceOrFail()).giveMira(args.amount);
    }
};

pub const Items = struct {
    ctx: *sdk.Context = undefined,
    item: u32 = 0,

    pub fn start(self: *Items, ctx: *sdk.Context) !void {
        self.ctx = ctx;
        try self.add(&.{});
        try ctx.spawn(listItems, .{ self, ctx.io });
    }

    fn listItems(self: *Items, io: std.Io) void {
        const items = while (true) {
            if (itemTable()) |found| if (found.len > 0) break found;
            sdk.frame.delay(io, .fromSeconds(1)) catch return;
        };
        var arena: std.heap.ArenaAllocator = .init(self.ctx.allocator);
        defer arena.deinit();
        const choices = arena.allocator().alloc(W.TweakChoice, items.len) catch return;
        for (items, choices) |item, *c| c.* = .{
            .value = @floatFromInt(item.id),
            .label = if (item.name) |name| std.mem.span(name) else "?",
        };
        self.add(choices) catch |err| std.log.warn("Couldn't list the items: {t}", .{err});
    }

    fn add(self: *Items, choices: []const W.TweakChoice) !void {
        try self.ctx.wraith.tweaks().add(.{
            .id = "spawn_item",
            .title = "Spawn item",
            .mode = .action,
            .fields = &.{.{ .name = "item", .type = .u32, .label = "Item", .choices = choices }},
        }, W.TweakHandler.init(self, spawnItemHandler));
    }

    fn spawnItemHandler(self: *Items, event: W.TweakEvent) !void {
        switch (event.kind) {
            .changed => if (std.mem.eql(u8, event.field, "item")) {
                self.item = @intFromFloat(event.value);
            },
            .on => {
                std.log.info("Spawning item {d}", .{self.item});
                _ = (try GameStateManager.instanceOrFail()).spawnItem(self.item, 1);
            },
            else => {},
        }
    }

    fn itemTable() ?[]schema.Item {
        const manager = schema.DataTableManager.instance() catch return null;
        const data = sdk.salamander.follow(manager, "items.table.data") orelse return null;
        return data.itemsSlice();
    }
};
