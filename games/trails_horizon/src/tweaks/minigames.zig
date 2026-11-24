//! Minigame tweaks: fishing, Grim Garten's stages, hacking and achievements. Each puts a few
//! bytes over the game's checks, found by their signatures, while it's on.

const std = @import("std");
const sdk = @import("wraith_sdk");
const schema = @import("schema");
const common = @import("common.zig");

const W = sdk.api.wraith;
const Atomic = sdk.atomic.Value;
const sections = common.sections;
const log = sdk.log.scoped(.trails_horizon);
const Text = @TypeOf(sdk.Module.main().text() catch unreachable);

/// Each on its own, so one the game's moved doesn't take the rest with it.
pub fn start(ctx: *sdk.Context) !void {
    const text = try sdk.Module.main().text();
    garten(ctx, text) catch |err| log.err("No Grim Garten tweaks: {t}", .{err});
    fishingExcellent(ctx, text) catch |err| log.err("No Always Excellent: {t}", .{err});
    one_hit.start(ctx) catch |err| log.err("No Catch in one hit: {t}", .{err});
    pick_fish.start(ctx) catch |err| log.err("No Pick the fish: {t}", .{err});
    fishingRank(ctx, text) catch |err| log.err("No Always rank A: {t}", .{err});
    hacking(ctx, text) catch |err| log.err("No Instant hacking: {t}", .{err});
    achievements(ctx, text) catch |err| log.err("No achievements tweak: {t}", .{err});
}

fn garten(ctx: *sdk.Context, text: Text) !void {
    // Grim Garten's stage objectives, in the function that checks all three. Each skips the
    // count against what's needed and marks it done.
    try common.patchTweak(ctx, .{ .id = "garten_objectives", .title = "Stage objectives are always met", .section = sections.garten }, &.{
        .{ .at = text.scan("garten: objective count", "7C ?? 41 C6 07 ?? 41 C6 45 ?? ?? E9 ?? ?? ?? ?? 83 F8"), .bytes = &.{ 0x90, 0x90 }, .expect = "7C" },
        .{ .at = text.scan("garten: objective flags", "0F 8D ?? ?? ?? ?? E9 ?? ?? ?? ?? 83 F8 ?? 75 ?? 33 DB"), .bytes = &.{ 0x90, 0xE9 }, .expect = "0F 8D" },
        .{ .at = text.scan("garten: objective enemies", "0F 8D ?? ?? ?? ?? E9 ?? ?? ?? ?? 8D 48 ?? 83 F9"), .bytes = &.{ 0x90, 0xE9 }, .expect = "0F 8D" },
        .{ .at = text.scan("garten: objective value", "7C ?? 41 C6 07 ?? 41 C6 45 ?? ?? EB ?? BA ?? ?? ?? ?? 48 8B 0D"), .bytes = &.{ 0x90, 0x90 }, .expect = "7C" },
    });
    // A rank's mission counts up by one at a time to what's needed. This takes it all the way.
    try common.patchTweak(ctx, .{ .id = "garten_ranks", .title = "Rank missions done in one go", .section = sections.garten }, &.{
        .{ .at = text.scan("garten: mission count", "45 0F 47 CA E8 ?? ?? ?? ?? 48 8B 7C 24 ?? 48 8B 5C 24"), .bytes = &.{ 0x90, 0x90, 0x90, 0x90 }, .expect = "45 0F 47 CA" },
    });
}

fn fishingExcellent(ctx: *sdk.Context, text: Text) !void {
    // The signature's read at compile time, and it's long, since the miss, great and excellent
    // branches all look alike till well into them
    @setEvalBranchQuota(20_000);
    // Reeling in, a miss goes where an Excellent does
    const timing = text.scan("fishing: timing", "0F 86 ?? ?? ?? ?? 0F 2F D4 72 ?? 0F 28 C1 F3 0F 5C C6");
    const excellent = text.scan("fishing: excellent", "48 8B 8B ?? ?? ?? ?? E8 ?? ?? ?? ?? 41 B0 ?? 48 8D 15 ?? ?? ?? ?? 48 8B C8 E8 ?? ?? ?? ?? 33 FF 89 7C 24 ?? C7 44 24 ?? ?? ?? ?? ?? 89 7C 24 ?? C7 44 24 ?? ?? ?? ?? ?? F3 44 0F 11 44 24 ?? F3 44 0F 11 4C 24 ?? 0F 57 DB 0F 57 D2 BA ?? ?? ?? ?? 48 8B 0D ?? ?? ?? ?? E8 ?? ?? ?? ?? F3 0F 10 83 ?? ?? ?? ?? 0F 28 C8 F3 0F 58 8B ?? ?? ?? ?? F3 0F 11 83 ?? ?? ?? ?? F3 0F 11 8B ?? ?? ?? ?? 48 C7 83 ?? ?? ?? ?? ?? ?? ?? ?? 89 BB ?? ?? ?? ?? E8 ?? ?? ?? ?? F3 44 0F 11 4C 24 ?? F3 44 0F 11 4C 24 ?? F3 0F 10 1D ?? ?? ?? ?? 41 0F 28 D0 F3 0F 10 0D");
    var jump: [6]u8 = .{ 0xE9, 0, 0, 0, 0, 0x90 };
    const from = try timing.unwrap();
    const rel: i32 = @intCast(@as(i64, @intCast(try excellent.unwrap())) - @as(i64, @intCast(from + 5)));
    std.mem.writeInt(i32, jump[1..5], rel, .little);
    try common.patchTweak(ctx, .{ .id = "fishing_excellent", .title = "Always Excellent", .section = sections.fishing }, &.{
        .{ .at = timing, .bytes = &jump, .expect = "0F 86" },
    });
}

fn fishingRank(ctx: *sdk.Context, text: Text) !void {
    // The size's chances, which skip straight to rank A's
    try common.patchTweak(ctx, .{ .id = "fishing_rank_a", .title = "Always rank A", .section = sections.fishing }, &.{
        .{ .at = text.scan("fishing: size", "83 7C 02 ?? ?? 75 ?? 83 7C F5 ?? ?? 74 ?? 41 BB"), .bytes = &.{ 0xEB, 0x05 }, .expect = "83 7C 02" },
        .{ .at = text.scan("fishing: big hit", "83 7C F5 ?? ?? 74 ?? 41 BB ?? ?? ?? ?? 41 BA ?? ?? ?? ?? F3 0F 10 A7"), .bytes = &.{ 0xEB, 0x05 }, .expect = "83 7C F5" },
    });
}

fn hacking(ctx: *sdk.Context, text: Text) !void {
    // Hacking's done as soon as it starts
    try common.patchTweak(ctx, .{ .id = "instant_hacking", .title = "Instant hacking", .section = sections.misc }, &.{
        .{ .at = text.scan("hacking: done", "80 B9 ?? ?? ?? ?? ?? 74 ?? 48 8B 89 ?? ?? ?? ?? 48 63 41"), .bytes = &.{ 0xEB, 0x07 }, .expect = "80 B9" },
    });
}

fn achievements(ctx: *sdk.Context, text: Text) !void {
    // achievement::Manager::CheckUnlock, which then doesn't wait for each one's count
    try common.patchTweak(ctx, .{ .id = "achievements", .title = "Unlock achievements without their requirements", .section = sections.misc }, &.{
        .{ .at = text.scan("achievements: count", "7D ?? 8B 53 ?? 48 8B 0D ?? ?? ?? ?? E8 ?? ?? ?? ?? 85 C0"), .bytes = &.{0xEB}, .expect = "7D" },
    });
}

/// Keeps the meter just short of full when reeling, so the next hit lands the fish, like the
/// Kuro no Kiseki II table's Easy fishing.
const OneHit = struct {
    const Reel = schema.Fishing.Fns.reel;
    const Hook = sdk.hooks.FnHook(Reel);
    /// Out of 100. Any hit's more than 1
    const nearly = 99;

    hook: Hook = undefined,

    fn start(self: *OneHit, ctx: *sdk.Context) !void {
        self.hook = try sdk.hooks.createFn(Reel, try schema.Fishing.addresses.reel(), detour, self);
        try sdk.tweaks.hook(ctx, .{ .id = "fishing_one_hit", .title = "Catch in one hit", .section = sections.fishing }, &self.hook);
    }

    fn detour(_: *OneHit, hook: Hook, fishing: *schema.Fishing) void {
        if (fishing.meter < nearly) fishing.meter = nearly;
        hook.original()(fishing);
    }
};

var one_hit: OneHit = .{};

/// Whatever bites is the fish that's picked, sized for it. The game still rolls first, so
/// nothing bites where nothing would.
const PickFish = struct {
    const Pick = schema.FishingSpot.Fns.pickFish;
    const Hook = sdk.hooks.FnHook(Pick);

    ctx: *sdk.Context = undefined,
    hook: Hook = undefined,
    fish: Atomic(u32) = .init(0),
    biggest: Atomic(bool) = .init(false),

    fn start(self: *PickFish, ctx: *sdk.Context) !void {
        self.ctx = ctx;
        self.hook = try sdk.hooks.createFn(Pick, try schema.FishingSpot.addresses.pickFish(), detour, self);
        try self.add(&.{});
        try ctx.spawn(listFish, .{ self, ctx.io });
    }

    /// Once the tables are loaded.
    fn listFish(self: *PickFish, io: std.Io) void {
        const rows = while (true) {
            if (fishRows()) |found| if (found.count > 0) break found;
            sdk.frame.delay(io, .fromSeconds(1)) catch return;
        };
        var arena: std.heap.ArenaAllocator = .init(self.ctx.allocator);
        defer arena.deinit();
        var choices: std.ArrayList(W.TweakChoice) = .empty;
        for (0..rows.count) |i| {
            const row = rows.at(i);
            const name = common.itemName(row.id) orelse continue;
            choices.append(arena.allocator(), .{ .value = @floatFromInt(row.id), .label = name }) catch return;
        }
        self.add(choices.items) catch |err| log.warn("Couldn't list the fish: {t}", .{err});
    }

    fn add(self: *PickFish, choices: []const W.TweakChoice) !void {
        try self.ctx.wraith.tweaks().addIn(sections.fishing, .{
            .id = "fishing_pick",
            .title = "Pick the fish",
            .fields = &.{
                .{ .name = "fish", .type = .u32, .label = "Fish", .choices = choices },
                .{ .name = "biggest", .type = .bool, .label = "Biggest it gets", .toggle = true },
            },
        }, W.TweakHandler.init(self, handle));
    }

    fn handle(self: *PickFish, event: W.TweakEvent) !void {
        switch (event.kind) {
            .changed => {
                if (std.mem.eql(u8, event.field, "fish")) self.fish.store(std.math.lossyCast(u32, event.value), .release);
                if (std.mem.eql(u8, event.field, "biggest")) self.biggest.store(event.value != 0, .release);
            },
            .on => self.hook.enable() catch return error.Failed,
            .off => self.hook.disable() catch {},
            else => {},
        }
    }

    fn detour(self: *PickFish, hook: Hook, spot: *schema.FishingSpot, maybe_size: ?*f32) u32 {
        const rolled = hook.original()(spot, maybe_size);
        const size = maybe_size orelse return rolled;
        const want = self.fish.load(.acquire);
        // 0's nothing biting
        if (rolled == 0 or want == 0 or want == rolled) return self.resize(rolled, rolled, size);
        const rows = fishRows() orelse return rolled;
        if (rows.find(want) == null) return rolled;
        return self.resize(rolled, want, size);
    }

    /// Keeps where the roll fell between the old fish's smallest and biggest, in the new one's.
    fn resize(self: *PickFish, rolled: u32, want: u32, size: *f32) u32 {
        const rows = fishRows() orelse return want;
        const new = rows.find(want) orelse return want;
        var t: f32 = 1;
        if (!self.biggest.load(.acquire)) if (rows.find(rolled)) |old| {
            const span = old.max_size - old.min_size;
            if (span > 0) t = std.math.clamp((size.* - old.min_size) / span, 0, 1);
        };
        size.* = new.min_size + t * (new.max_size - new.min_size);
        return want;
    }
};

var pick_fish: PickFish = .{};

const FishRows = struct {
    base: usize,
    stride: usize,
    count: usize,

    fn at(self: FishRows, i: usize) *const schema.FishRow {
        return @ptrFromInt(self.base + i * self.stride);
    }

    fn find(self: FishRows, id: u32) ?*const schema.FishRow {
        for (0..self.count) |i| if (self.at(i).id == id) return self.at(i);
        return null;
    }
};

/// t_minigame_fishing's FishInfo, once it's loaded.
fn fishRows() ?FishRows {
    const manager = schema.DataTableManager.instance() catch return null;
    const table = sdk.salamander.follow(manager, "fishing.table") orelse return null;
    const all: [*]const schema.TableSection = @ptrCast(table.sections orelse return null);
    const s = &all[table.fish_section];
    return .{ .base = table.data + s.offset, .stride = s.stride, .count = s.count };
}
