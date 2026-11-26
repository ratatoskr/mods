//! Item tweaks: spawning them, keeping them and full stacks.

const std = @import("std");
const sdk = @import("wraith_sdk");
const schema = @import("schema").TrailsHorizon;
const common = @import("common.zig");

const W = sdk.api.wraith;
const Atomic = sdk.atomic.Value;
const sections = common.sections;

const GameStateManager = schema.GameStateManager;

pub const Items = struct {
    const AddHook = sdk.hooks.Hook(GameStateManager, .spawnItem);
    const SubHook = sdk.hooks.Hook(GameStateManager, .subItem);

    ctx: *sdk.Context = undefined,
    item: u32 = 0,
    sub_item: SubHook = undefined,
    add_item: AddHook = undefined,

    pub fn start(self: *Items, ctx: *sdk.Context) !void {
        self.ctx = ctx;
        try self.add(&.{});
        try ctx.spawn(listItems, .{ self, ctx.io });
        self.sub_item = try sdk.hooks.hook(GameStateManager, .subItem, subItemDetour, self);
        try sdk.tweaks.hook(ctx, .{ .id = "keep_items", .title = "Items aren't used up", .section = sections.items }, &self.sub_item);
        self.add_item = try sdk.hooks.hook(GameStateManager, .spawnItem, addItemDetour, self);
        try sdk.tweaks.hook(ctx, .{ .id = "full_stacks", .title = "Full stacks", .section = sections.items }, &self.add_item);
    }

    fn subItemDetour(_: *Items, hook: SubHook, manager: *GameStateManager, id: u32, quantity: u32) bool {
        // Sepith still gets spent
        if (common.isItem(id)) return true;
        return hook.original()(manager, id, quantity);
    }

    fn addItemDetour(_: *Items, hook: AddHook, manager: *GameStateManager, id: u32, quantity: u32) bool {
        const added = hook.original()(manager, id, quantity);
        if (added and common.isItem(id)) fillUp(manager, id);
        return added;
    }

    /// Near the most you can carry, leaving room so more can still be picked up.
    fn fillUp(manager: *GameStateManager, id: u32) void {
        if (id >= manager.inventory.len) return;
        const items = common.itemTable() orelse return;
        const max = for (items) |it| {
            if (it.id == id) break it.max_count;
        } else return;
        const slot = &manager.inventory[id];
        const room: u32 = if (max > 101) 21 else if (max > 20) 10 else 0;
        slot.count = @intCast(@max(slot.count, @min(max - room, std.math.maxInt(u16))));
    }

    fn listItems(self: *Items, io: std.Io) void {
        const items = while (true) {
            if (common.itemTable()) |found| if (found.len > 0) break found;
            sdk.threads.delay(io, .fromSeconds(1)) catch return;
        };
        var arena: std.heap.ArenaAllocator = .init(self.ctx.allocator);
        defer arena.deinit();
        const choices = arena.allocator().alloc(W.Tweaks.Choice, items.len) catch return;
        for (items, choices) |item, *c| c.* = .{
            .value = @floatFromInt(item.id),
            .label = if (item.name) |name| std.mem.span(name) else "?",
        };
        self.add(choices) catch |err| std.log.warn("Couldn't list the items: {t}", .{err});
    }

    fn add(self: *Items, choices: []const W.Tweaks.Choice) !void {
        try self.ctx.wraith.tweaks().addIn(sections.items, .{
            .id = "spawn_item",
            .title = "Spawn item",
            .mode = .action,
            .fields = &.{.{ .name = "item", .type = .u32, .label = "Item", .choices = choices }},
        }, W.Tweaks.Handler.init(self, spawnItemHandler));
    }

    fn spawnItemHandler(self: *Items, event: W.Tweaks.Event) !void {
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
};
