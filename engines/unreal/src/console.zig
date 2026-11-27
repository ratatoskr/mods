//! Unreal's console. Shipping games often leave it out, so the game viewport gets one made if it has
//! none, and the usual key opens it. Wraith's own console window runs commands too, for games whose
//! console keys are gone. Commands run on the game thread through `ExecuteConsoleCommand`.

const std = @import("std");
const sdk = @import("wraith_sdk");

const World = @import("ue/World.zig");
const TArray = @import("ue/Unreal.zig").TArray;
const Loop = @import("loop.zig").Loop;

const log = sdk.log.scoped(.unreal);
const ui = sdk.ui;

const P = @sizeOf(usize);
const max_len = 512;
const max_pending = 16;
const max_history = 64;

pub const Console = struct {
    window: ui.Window = .{ .title = "Unreal console##unreal", .size = .{ 560, 320 } },
    world: ?*const World = null,
    loop: ?*Loop = null,
    input: [max_len]u8 = @splat(0),
    focus: bool = true,
    /// Render thread only.
    history: [max_history][max_len]u8 = undefined,
    history_lens: [max_history]usize = @splat(0),
    history_len: usize = 0,
    /// From the render thread to the game thread.
    pending: [max_pending][max_len]u8 = undefined,
    pending_lens: [max_pending]usize = @splat(0),
    pending_len: usize = 0,
    lock: sdk.sync.RwLock = .{},
    /// Game thread only.
    unlocked: bool = false,
    unlock_tries: u32 = 0,

    pub fn start(self: *Console, world: *const World, loop: *Loop) void {
        self.world = world;
        self.loop = loop;
    }

    pub fn onOpen(self: *Console) void {
        self.focus = true;
    }

    pub fn draw(self: *Console) void {
        if (self.world == null) {
            ui.textDisabled("Waiting for the game's engine", .{});
            return;
        }
        if (self.world.?.console_command == null) {
            ui.textWrapped("This game has no ExecuteConsoleCommand, so commands can't be run.", .{});
            return;
        }
        // Leaves a line for the box
        if (ui.child("##history", .{ 0, -(ui.frameHeight() + ui.getStyle().item_spacing[1]) }, .{})) |scope| {
            defer scope.end();
            for (0..self.history_len) |i| {
                const line = self.history[i][0..self.history_lens[i]];
                ui.textUnformatted(line);
                // Clicking one puts it back in the box
                if (ui.isItemClicked(.left)) {
                    @memset(&self.input, 0);
                    @memcpy(self.input[0..line.len], line);
                    self.focus = true;
                }
            }
            if (ui.getScrollY() >= ui.getScrollMaxY()) ui.setScrollHereY(1);
        }
        ui.setNextItemWidth(-1);
        if (self.focus) {
            ui.focusNext();
            self.focus = false;
        }
        if (ui.inputTextWith("##command", &self.input, .{ .flags = .{ .enter_returns_true = true }, .hint = "A command, like stat fps or t.MaxFPS 60" })) {
            const command = std.mem.trim(u8, std.mem.sliceTo(&self.input, 0), " ");
            if (command.len > 0) self.send(command);
            @memset(&self.input, 0);
            self.focus = true;
        }
    }

    fn send(self: *Console, command: []const u8) void {
        if (self.history_len == max_history) {
            std.mem.copyForwards([max_len]u8, self.history[0 .. max_history - 1], self.history[1..]);
            std.mem.copyForwards(usize, self.history_lens[0 .. max_history - 1], self.history_lens[1..]);
            self.history_len -= 1;
        }
        @memcpy(self.history[self.history_len][0..command.len], command);
        self.history_lens[self.history_len] = command.len;
        self.history_len += 1;

        self.lock.lock();
        defer self.lock.unlock();
        if (self.pending_len == max_pending) return;
        @memcpy(self.pending[self.pending_len][0..command.len], command);
        self.pending_lens[self.pending_len] = command.len;
        self.pending_len += 1;
    }

    /// Game thread, once a tick.
    pub fn tick(self: *Console) void {
        const world = self.world orelse return;
        if (!self.unlocked and self.unlock_tries < 600) {
            self.unlock_tries += 1;
            self.unlocked = self.unlock(world);
        }
        var commands: [max_pending][max_len]u8 = undefined;
        var lens: [max_pending]usize = undefined;
        const n = blk: {
            self.lock.lock();
            defer self.lock.unlock();
            const n = self.pending_len;
            for (0..n) |i| {
                commands[i] = self.pending[i];
                lens[i] = self.pending_lens[i];
            }
            self.pending_len = 0;
            break :blk n;
        };
        for (0..n) |i| self.run(world, commands[i][0..lens[i]]);
    }

    fn run(self: *Console, world: *const World, command: []const u8) void {
        const loop = self.loop orelse return;
        if (world.world() == null) return log.warn("No world to run \"{s}\" in yet", .{command});
        if (runCommand(world, loop, command)) log.info("Ran \"{s}\"", .{command});
    }

    /// True once there's a console, ours or the game's, or there's no making one.
    fn unlock(self: *Console, world: *const World) bool {
        const mem = world.ue.mem;
        const console_at = world.off.viewport_console orelse return true;
        const viewport = world.viewport() orelse return false;
        // Game thread, where the engine and its viewport are alive, so it's read plainly
        if (mem.live(usize, viewport + console_at) != 0) return true;
        // Wait for the first world, so it's made the way the game would
        if (world.world() == null) return false;
        const spawn = world.spawn_object orelse {
            log.info("The game has no console, and no SpawnObject to make one with", .{});
            return true;
        };
        const loop = self.loop orelse return false;
        const class = blk: {
            if (world.off.console_class) |at| {
                const c = mem.live(usize, world.engine + at);
                if (c != 0) break :blk c;
            }
            break :blk world.console_class;
        };
        if (class == 0) return true;
        var params: [64]u8 align(16) = @splat(0);
        if (spawn.size > params.len) return true;
        std.mem.writeInt(usize, params[spawn.params[0]..][0..P], class, .little);
        std.mem.writeInt(usize, params[spawn.params[1]..][0..P], viewport, .little);
        loop.call(spawn.object, spawn.function, params[0..spawn.size]);
        const console = std.mem.readInt(usize, params[spawn.params[2]..][0..P], .little);
        if (console == 0) {
            log.warn("Couldn't make the game a console", .{});
            return true;
        }
        mem.setLive(usize, viewport + console_at, console);
        log.info("The game had no console, so it has one now. {s}", .{keysNote(world)});
        return true;
    }
};

/// Runs `command` as the console would. False if there's no world or no way to. Game thread.
pub fn runCommand(world: *const World, loop: *Loop, command: []const u8) bool {
    const f = world.console_command orelse return false;
    const w = world.world() orelse return false;
    var wide: [max_len + 1]u16 = undefined;
    const len = std.unicode.utf8ToUtf16Le(&wide, command) catch return false;
    wide[len] = 0;
    var params: [256]u8 align(16) = @splat(0);
    if (f.size > params.len) return false;
    std.mem.writeInt(usize, params[f.params[0]..][0..P], w, .little);
    writeString(params[f.params[1]..][0..@sizeOf(TArray)], wide[0 .. len + 1]);
    loop.call(f.object, f.function, params[0..f.size]);
    return true;
}

/// A console variable's value as a whole number, or null if it can't be read. Game thread.
pub fn intVariable(world: *const World, loop: *Loop, name: []const u8) ?i32 {
    const f = world.cvar_int orelse return null;
    var wide: [128]u16 = undefined;
    const len = std.unicode.utf8ToUtf16Le(wide[0 .. wide.len - 1], name) catch return null;
    wide[len] = 0;
    var params: [64]u8 align(16) = @splat(0);
    if (f.size > params.len) return null;
    writeString(params[f.params[0]..][0..@sizeOf(TArray)], wide[0 .. len + 1]);
    loop.call(f.object, f.function, params[0..f.size]);
    return std.mem.readInt(i32, params[f.params[1]..][0..4], .little);
}

/// Which key opens it, from the input settings.
fn keysNote(world: *const World) []const u8 {
    const at = world.off.console_keys orelse return "";
    if (world.input_settings == 0) return "";
    // A class default, there for good
    const count = world.ue.mem.live(i32, world.input_settings + at + @offsetOf(TArray, "num"));
    return if (count > 0) "The game's console key opens it, usually ` or ~" else "The game has no console key set, so use Wraith's Unreal console window";
}

/// An FString pointing at `text`, which ends in 0 and has to outlive the call.
fn writeString(out: *[@sizeOf(TArray)]u8, text: []const u16) void {
    const s: TArray = .{ .data = @intFromPtr(text.ptr), .num = @intCast(text.len), .max = @intCast(text.len) };
    out.* = std.mem.toBytes(s);
}
