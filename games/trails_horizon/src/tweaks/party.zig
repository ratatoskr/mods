//! The Party window: each route's members in order, who leads, attacks, supports or waits in
//! reserve, and their flags. The game thread copies the shown party out each tick while it's open
//! and the window draws from that.
//! Changes go back to the game thread, where Party's own methods make them, and the field puts the
//! new party out on its next update.

const std = @import("std");
const sdk = @import("wraith_sdk");
const schema = @import("schema").TrailsHorizon;
const common = @import("common.zig");

const ui = sdk.ui;
const log = sdk.log.scoped(.trails_horizon);

const FieldManager = schema.FieldManager;
const GameStateManager = schema.GameStateManager;
const Flags = schema.PartyFlags;

/// Routes the field keeps a party for
const party_count = 11;
const no_one = 0xFFFF;
const max_members = 64;
const max_roster = 128;
const max_pending = 16;
/// Attack, the rest of the lineup supports
const fighters = 4;
const drag_kind = "trails_party_member";

const Member = struct {
    chrid: u32,
    flags: Flags,
};

/// What the window draws, copied out on the game thread.
const View = struct {
    ready: bool = false,
    playing: u32 = 0,
    route: u32 = 0,
    members: [max_members]Member = undefined,
    count: u32 = 0,
    leader: u32 = 0,
    front: u32 = 0,
    /// Each route's leader, to tell them apart. `no_one` for an empty one
    leaders: [party_count]u32 = @splat(no_one),
    roster: [max_roster]u32 = undefined,
    roster_count: u32 = 0,

    fn shown(self: *const View) []const Member {
        return self.members[0..self.count];
    }

    fn has(self: *const View, chrid: u32) bool {
        for (self.shown()) |m| if (m.chrid == chrid) return true;
        return false;
    }
};

const Change = struct {
    route: u32,
    what: union(enum) {
        add: u32,
        remove: u32,
        swap: [2]u32,
        leader: u32,
        front: u32,
        flags: struct { who: u32, flags: Flags },
    },
};

/// A flag's checkbox in the window.
const FlagInfo = struct {
    field: []const u8,
    label: [:0]const u8,
    tip: []const u8,
};

const flag_infos = [_]FlagInfo{
    .{ .field = "equip_locked", .label = "Equipment locked", .tip = "Their equipment can't be changed" },
    .{ .field = "forced_attacker", .label = "Forced attacker", .tip = "Has to be one of the 4 attacking" },
    .{ .field = "extra", .label = "Extra", .tip = "Joined as an extra, so they can't be moved or swapped" },
};

/// Bits nobody's worked out yet, shown raw.
const unknown_infos = [_]FlagInfo{
    .{ .field = "unknown_4", .label = "0x4", .tip = "A script command clears it with Extra" },
    .{ .field = "unknown_10", .label = "0x10", .tip = "A script command sets it, but nothing in the party reads it" },
    .{ .field = "unknown_200", .label = "0x200", .tip = "Not seen used" },
    .{ .field = "unknown_400", .label = "0x400", .tip = "Checked with Equipment locked before the party menu swaps them" },
};

const join_names = [_][:0]const u8{ "Normal", "Guest", "Extra" };
const lock_names = [_][:0]const u8{ "Not locked", "Locked to reserve", "Locked in the lineup" };

const Choice = struct { value: f64, label: []const u8 };

pub const Party = struct {
    window: ui.Window = .{ .title = "Party##trails_horizon", .size = .{ 340, 460 }, .min_size = .{ 280, 260 } },
    ctx: *sdk.Context = undefined,
    tick_sub: ?sdk.frame.FrameSubscription = null,
    lock: sdk.sync.RwLock = .{},
    /// Under `lock`
    view: View = .{},
    pending: [max_pending]Change = undefined,
    pending_len: usize = 0,
    /// Under `lock`. The route the window shows, or `no_one` for the one that's playing
    route: u32 = no_one,
    /// Render thread only
    picked: u32 = no_one,
    /// Who the Add picker's on, render thread only
    adding: f64 = no_one,

    pub fn start(self: *Party, ctx: *sdk.Context) !void {
        self.ctx = ctx;
        try ctx.addWindow(self);
        try ctx.menuItem("Party", &self.window.open);
        try sdk.tweaks.opens(ctx, .{ .id = "party", .title = "Party members", .section = common.sections.party }, &self.window);
        self.tick_sub = try sdk.frame.onTick(self, tick);
    }

    /// Waits for a tick in flight.
    pub fn stop(self: *Party) void {
        if (self.tick_sub) |s| s.unsubscribe();
        self.tick_sub = null;
    }

    // The game thread

    fn tick(self: *Party) void {
        var changes: [max_pending]Change = undefined;
        var wanted: u32 = no_one;
        const n = blk: {
            self.lock.lock();
            defer self.lock.unlock();
            const n = self.pending_len;
            @memcpy(changes[0..n], self.pending[0..n]);
            self.pending_len = 0;
            wanted = self.route;
            break :blk n;
        };
        const field = (FieldManager.instance() catch null) orelse return self.publish(.{});
        const parties: [*]schema.Party = @ptrCast(field.parties orelse return self.publish(.{}));
        var refresh = false;
        for (changes[0..n]) |c| {
            if (c.route >= party_count) continue;
            if (!apply(&parties[c.route], c)) log.warn("The game wouldn't change the party ({t})", .{c.what});
            if (c.route == field.current_party) refresh = true;
        }
        if (refresh) field.applyParty(0, false);
        if (!self.window.open) return;

        var v: View = .{ .ready = true, .playing = field.current_party };
        v.route = if (wanted < party_count) wanted else field.current_party;
        if (v.route >= party_count) return self.publish(.{});
        for (0..party_count) |i| {
            const p = &parties[i];
            const slots = slotsOf(p);
            if (slots.len > 0) v.leaders[i] = slots[@min(p.leader, slots.len - 1)].chrid;
        }
        const party = &parties[v.route];
        const slots = slotsOf(party);
        v.count = @intCast(@min(slots.len, max_members));
        for (slots[0..v.count], v.members[0..v.count]) |s, *m| m.* = .{ .chrid = s.chrid, .flags = s.flags };
        v.leader = party.leader;
        v.front = party.front;
        if (GameStateManager.instance() catch null) |manager| {
            for (&manager.roster) |*s| {
                if (s.id == 0 or s.id >= no_one or v.roster_count == max_roster) continue;
                const seen = std.mem.findScalar(u32, v.roster[0..v.roster_count], s.id) != null;
                if (!seen) {
                    v.roster[v.roster_count] = s.id;
                    v.roster_count += 1;
                }
            }
        }
        self.publish(v);
    }

    fn publish(self: *Party, v: View) void {
        self.lock.lock();
        defer self.lock.unlock();
        self.view = v;
    }

    fn slotsOf(party: *schema.Party) []schema.PartySlot {
        const slots: [*]schema.PartySlot = @ptrCast(party.slots orelse return &.{});
        return slots[0..@min(party.count, max_members)];
    }

    fn apply(party: *schema.Party, c: Change) bool {
        return switch (c.what) {
            .add => |who| party.add(who, 0),
            .remove => |who| party.remove(who),
            .swap => |pair| swap(party, pair[0], pair[1]),
            .leader => |who| blk: {
                party.setLeader(who);
                break :blk true;
            },
            .front => |count| party.setFrontCount(count),
            .flags => |f| setFlags(party, f.who, f.flags),
        };
    }

    /// Trades their places. The game's own rule is that guests stay put and whoever must fight
    /// stays in the first 4.
    fn swap(party: *schema.Party, a: u32, b: u32) bool {
        const slots = slotsOf(party);
        const i = indexIn(slots, a) orelse return false;
        const j = indexIn(slots, b) orelse return false;
        if (i == j) return true;
        if (isGuest(slots[i].flags) or isGuest(slots[j].flags)) return false;
        if (!fits(slots[i].flags, j, party.front) or !fits(slots[j].flags, i, party.front)) return false;
        const leader = if (party.leader < slots.len) slots[party.leader].chrid else no_one;
        std.mem.swap(schema.PartySlot, &slots[i], &slots[j]);
        // The leader's kept by who they are, not where
        if (leader != no_one) party.setLeader(leader);
        return true;
    }

    /// Whether their flags let them be at `at`, like the game's own party menu checks.
    fn fits(f: Flags, at: usize, front: u32) bool {
        if (f.forced_attacker == 1 and at >= fighters) return false;
        return switch (f.lock) {
            .lineup => at < front,
            .reserve => at >= front,
            else => true,
        };
    }

    /// Locking to reserve goes through the game, which moves them to fit. The rest are just bits.
    fn setFlags(party: *schema.Party, who: u32, flags: Flags) bool {
        const slots = slotsOf(party);
        const i = indexIn(slots, who) orelse return false;
        const old = slots[i].flags;
        const was_reserve = old.lock == .reserve;
        const now_reserve = flags.lock == .reserve;
        var plain = flags;
        // Bit 6 is the reserve lock, which the game sets itself below
        if (now_reserve != was_reserve) plain.lock = if (was_reserve) .reserve else .none;
        slots[i].flags = plain;
        if (now_reserve != was_reserve) {
            if (!party.lockToReserve(who, now_reserve)) return false;
            // Reserve and lineup share the bits, so set lineup once it's out of reserve
            if (flags.lock == .lineup) if (indexIn(slotsOf(party), who)) |k| {
                slotsOf(party)[k].flags.lock = .lineup;
            };
        }
        return true;
    }

    fn indexIn(slots: []const schema.PartySlot, chrid: u32) ?usize {
        for (slots, 0..) |s, i| if (s.chrid == chrid) return i;
        return null;
    }

    fn isGuest(f: Flags) bool {
        return f.join != .normal or f.extra == 1;
    }

    // The render thread

    fn request(self: *Party, route: u32, what: @FieldType(Change, "what")) void {
        self.lock.lock();
        defer self.lock.unlock();
        if (self.pending_len == max_pending) return;
        self.pending[self.pending_len] = .{ .route = route, .what = what };
        self.pending_len += 1;
    }

    pub fn draw(self: *Party) void {
        const v = blk: {
            self.lock.lockShared();
            defer self.lock.unlockShared();
            break :blk self.view;
        };
        if (!v.ready) {
            ui.textDisabled("Load a save to see the party", .{});
            return;
        }
        if (!v.has(self.picked)) self.picked = if (v.count > 0) v.members[0].chrid else no_one;
        self.drawRoutes(&v);
        self.drawFront(&v);
        self.drawMembers(&v);
        self.drawPicked(&v);
        self.drawAdd(&v);
    }

    fn drawRoutes(self: *Party, v: *const View) void {
        var buf: [96]u8 = undefined;
        ui.setNextItemWidth(ui.fill);
        const combo = ui.comboBegin("##route", routeLabel(&buf, v, v.route), .{}) orelse return;
        defer combo.end();
        for (0..party_count) |i| {
            const route: u32 = @intCast(i);
            if (v.leaders[i] == no_one) continue;
            var item: [96]u8 = undefined;
            const label = routeLabel(&item, v, route);
            if (ui.selectable(label, route == v.route)) {
                self.lock.lock();
                defer self.lock.unlock();
                self.route = if (route == v.playing) no_one else route;
                self.picked = no_one;
            }
        }
    }

    fn routeLabel(buf: []u8, v: *const View, route: u32) [:0]const u8 {
        const leader = v.leaders[route];
        const playing: []const u8 = if (route == v.playing) ", playing" else "";
        if (leader == no_one) return std.fmt.bufPrintSentinel(buf, "Party {d} (empty{s})", .{ route + 1, playing }, 0) catch "";
        var name_buf: [16]u8 = undefined;
        return std.fmt.bufPrintSentinel(buf, "{s}'s party ({d}{s})", .{ nameOr(&name_buf, leader), route + 1, playing }, 0) catch "";
    }

    fn drawFront(self: *Party, v: *const View) void {
        ui.alignTextToFramePadding();
        ui.text("Attackers and support: {d}", .{v.front});
        ui.tooltip("How many are in the battle lineup. The first 4 attack, the rest support, and anyone past them is in reserve", .{});
        ui.sameLine();
        {
            const off = ui.disabled(v.front <= 1);
            defer off.end();
            if (ui.smallButton("-##front")) self.request(v.route, .{ .front = v.front - 1 });
        }
        ui.sameLine();
        const off = ui.disabled(v.front >= 8);
        defer off.end();
        if (ui.smallButton("+##front")) self.request(v.route, .{ .front = v.front + 1 });
    }

    fn drawMembers(self: *Party, v: *const View) void {
        // Leaves room for the picked one's flags
        const height = ui.getContentRegionAvailPixels()[1] * 0.45 / ui.scale();
        const t = ui.table("##members", 3, .{ .row_background = true, .scroll_y = true, .height = @max(height, 80) }) orelse return;
        defer t.end();
        ui.tableColumnWith("#", .{ .fixed = true, .width = 22 });
        ui.tableColumnWith("Name", .{ .stretch = true });
        ui.tableColumnWith("Role", .{ .fixed = true, .width = 80 });
        var buf: [16]u8 = undefined;
        var label: [32]u8 = undefined;
        for (v.shown(), 0..) |m, i| {
            const row = ui.id(@as(i32, @intCast(i)));
            defer row.end();
            ui.tableNextRow();
            _ = ui.tableNextColumn();
            const text = std.fmt.bufPrintSentinel(&label, "{d}", .{i + 1}, 0) catch "";
            if (ui.selectableWith(text, m.chrid == self.picked, .{ .span_columns = true })) self.picked = m.chrid;
            self.dragAndDrop(v, m);
            self.rowMenu(v, m, i);
            _ = ui.tableNextColumn();
            ui.text("{s}", .{nameOr(&buf, m.chrid)});
            _ = ui.tableNextColumn();
            const r = role(v, i, m.flags);
            if (i == v.leader) ui.textColored(gold, "Leader", .{}) else if (r.dim) ui.textDisabled("{s}", .{r.label}) else ui.text("{s}", .{r.label});
            if (i == v.leader) ui.tooltip("{s}, and leading", .{r.label});
        }
    }

    /// Dropping one on another trades their places.
    fn dragAndDrop(self: *Party, v: *const View, m: Member) void {
        if (!isGuest(m.flags)) {
            if (ui.dragSource(drag_kind, std.mem.asBytes(&m.chrid))) |src| {
                defer src.end();
                var buf: [16]u8 = undefined;
                ui.text("Swap {s} with...", .{nameOr(&buf, m.chrid)});
            }
        }
        const drop = ui.dropTarget(drag_kind) orelse return;
        if (!drop.delivered) return;
        const from = drop.as(u32) orelse return;
        if (from != m.chrid) self.request(v.route, .{ .swap = .{ from, m.chrid } });
    }

    fn rowMenu(self: *Party, v: *const View, m: Member, i: usize) void {
        const menu = ui.contextMenu("##member") orelse return;
        defer menu.end();
        self.picked = m.chrid;
        const guest = isGuest(m.flags);
        if (ui.menuItem("Make leader", .{ .enabled = i != v.leader and i < fighters and !guest })) self.request(v.route, .{ .leader = m.chrid });
        if (ui.menuItem("Move up", .{ .enabled = i > 0 and !guest })) self.request(v.route, .{ .swap = .{ m.chrid, v.members[i - 1].chrid } });
        if (ui.menuItem("Move down", .{ .enabled = i + 1 < v.count and !guest })) self.request(v.route, .{ .swap = .{ m.chrid, v.members[i + 1].chrid } });
        ui.separator();
        if (ui.menuItem("Take out", .{ .enabled = v.count > 1 })) self.request(v.route, .{ .remove = m.chrid });
    }

    fn drawPicked(self: *Party, v: *const View) void {
        const at = for (v.shown(), 0..) |m, i| {
            if (m.chrid == self.picked) break i;
        } else return;
        const m = v.members[at];
        var buf: [16]u8 = undefined;
        var title: [48]u8 = undefined;
        ui.separatorText(std.fmt.bufPrintSentinel(&title, "{s}", .{nameOr(&buf, m.chrid)}, 0) catch "");
        const guest = isGuest(m.flags);
        {
            const off = ui.disabled(at == v.leader or at >= fighters or guest);
            defer off.end();
            if (ui.smallButton("Make leader")) self.request(v.route, .{ .leader = m.chrid });
        }
        ui.sameLine();
        {
            const off = ui.disabled(at == 0 or guest);
            defer off.end();
            if (ui.smallButton("Up")) self.request(v.route, .{ .swap = .{ m.chrid, v.members[at - 1].chrid } });
        }
        ui.sameLine();
        {
            const off = ui.disabled(at + 1 >= v.count or guest);
            defer off.end();
            if (ui.smallButton("Down")) self.request(v.route, .{ .swap = .{ m.chrid, v.members[at + 1].chrid } });
        }
        ui.sameLine();
        {
            const off = ui.disabled(v.count <= 1);
            defer off.end();
            if (ui.smallButton("Take out")) self.request(v.route, .{ .remove = m.chrid });
        }
        self.drawFlags(v, m);
    }

    fn drawFlags(self: *Party, v: *const View, m: Member) void {
        const Join = @FieldType(Flags, "join");
        const Lock = @FieldType(Flags, "lock");
        var join: usize = @min(@backingInt(m.flags.join), join_names.len - 1);
        ui.setNextItemWidth(ui.fill);
        if (ui.combo("##join", &join, &join_names)) {
            var flags = m.flags;
            flags.join = @fromBackingInt(@as(@typeInfo(Join).@"enum".tag_type, @intCast(join)));
            self.request(v.route, .{ .flags = .{ .who = m.chrid, .flags = flags } });
        }
        ui.tooltip("How they joined. Guests and extras can't be moved or swapped", .{});
        var lock: usize = @min(@backingInt(m.flags.lock), lock_names.len - 1);
        ui.setNextItemWidth(ui.fill);
        if (ui.combo("##lock", &lock, &lock_names)) {
            var flags = m.flags;
            flags.lock = @fromBackingInt(@as(@typeInfo(Lock).@"enum".tag_type, @intCast(lock)));
            self.request(v.route, .{ .flags = .{ .who = m.chrid, .flags = flags } });
        }
        ui.tooltip("Kept in reserve, or kept attacking or supporting", .{});
        self.checkboxes(v, m, &flag_infos);
        if (ui.treeNode("Unknown flags")) |node| {
            defer node.end();
            self.checkboxes(v, m, &unknown_infos);
        }
    }

    fn checkboxes(self: *Party, v: *const View, m: Member, comptime infos: []const FlagInfo) void {
        inline for (infos) |f| {
            var on = @field(m.flags, f.field) == 1;
            if (ui.checkbox(f.label, &on)) {
                var flags = m.flags;
                @field(flags, f.field) = @intFromBool(on);
                self.request(v.route, .{ .flags = .{ .who = m.chrid, .flags = flags } });
            }
            ui.tooltip("{s}", .{f.tip});
        }
    }

    /// Anyone in the save who isn't in the party, searchable, or any id with Shift+click.
    fn drawAdd(self: *Party, v: *const View) void {
        var choices: [max_roster]Choice = undefined;
        var n: usize = 0;
        for (v.roster[0..v.roster_count]) |chrid| {
            if (v.has(chrid)) continue;
            const name = common.nameOf(chrid) orelse continue;
            choices[n] = .{ .value = @floatFromInt(chrid), .label = name };
            n += 1;
        }
        const listed = for (choices[0..n]) |c| {
            if (c.value == self.adding) break true;
        } else false;
        // A typed-in id stays, a listed one that's joined moves on
        if (!listed and (self.adding == no_one or v.has(@intFromFloat(self.adding)))) self.adding = if (n > 0) choices[0].value else no_one;
        ui.spacing();
        const add_width = ui.calcTextSize("Add")[0] + ui.getStyle().frame_padding[0] * 2;
        ui.setNextItemWidthPixels(ui.getContentRegionAvailPixels()[0] - add_width - ui.getStyle().item_spacing[0]);
        if (ui.choose("##adding", choices[0..n], self.adding, false)) |picked| self.adding = picked;
        ui.tooltip("Shift+click to type an id", .{});
        ui.sameLine();
        const who: u32 = std.math.lossyCast(u32, self.adding);
        const off = ui.disabled(who == 0 or who >= no_one or v.has(who));
        defer off.end();
        if (ui.button("Add")) {
            self.request(v.route, .{ .add = who });
            self.picked = who;
        }
    }
};
const gold: ui.Color = .{ 1, 0.8, 0.3, 1 };

const Role = struct {
    label: []const u8,
    dim: bool = false,
};

fn role(v: *const View, i: usize, f: Flags) Role {
    if (f.join == .guest) return .{ .label = "Guest", .dim = true };
    if (f.join == .extra or f.extra == 1) return .{ .label = "Extra", .dim = true };
    if (i < fighters and i < v.front) return .{ .label = "Attacker" };
    if (i < v.front) return .{ .label = "Support" };
    return .{ .label = "Reserve", .dim = true };
}

/// Their t_name name, else their id.
fn nameOr(buf: []u8, chrid: u32) []const u8 {
    if (common.nameOf(chrid)) |name| return name;
    return std.fmt.bufPrint(buf, "#{d}", .{chrid}) catch "?";
}
