//! The running game through the engine's own objects: the engine, its game viewport and world, the
//! world's settings, and the local player. Every offset comes from reflection, by property name, so
//! any version and any game's subclasses work.

const std = @import("std");

const Unreal = @import("Unreal.zig");

const World = @This();

ue: *const Unreal,
engine: usize,
off: Offsets,
/// `KismetSystemLibrary.ExecuteConsoleCommand`, called on its class default.
console_command: ?Function = null,
/// `GameplayStatics.SpawnObject`, 4.20 and later.
spawn_object: ?Function = null,
/// The `Console` class, for a game that ships without one made.
console_class: usize = 0,
/// `InputSettings`' defaults, where the keys that open the console are.
input_settings: usize = 0,

const Offsets = struct {
    game_viewport: usize,
    game_instance: usize,
    world: usize,
    persistent_level: usize,
    world_settings: usize,
    time_dilation: usize,
    pauser: usize,
    local_players: usize,
    player_controller: usize,
    player_state: usize,
    viewport_console: ?usize,
    console_class: ?usize,
    console_keys: ?usize,
};

/// A UFunction and the object it's called on, with where its params go.
pub const Function = struct {
    object: usize,
    function: usize,
    /// Bytes its params take.
    size: usize,
    /// Each param's offset, in the order they were asked for.
    params: [4]usize = @splat(0),
};

const classes = [_][]const u8{
    "Engine",                   "GameEngine",          "GameViewportClient",           "World",
    "Level",                    "WorldSettings",       "GameInstance",                 "Player",
    "Controller",               "KismetSystemLibrary", "Default__KismetSystemLibrary", "GameplayStatics",
    "Default__GameplayStatics", "Console",             "InputSettings",                "Default__InputSettings",
};
const C = enum { engine, game_engine, viewport, world, level, world_settings, game_instance, player, controller, kismet, kismet_cdo, statics, statics_cdo, console, input, input_cdo };

pub fn find(ue: *const Unreal, missing: *[]const u8) !World {
    var found: [classes.len]usize = undefined;
    ue.findIn("/Script/Engine", &classes, &found);
    const get = struct {
        fn get(f: []const usize, c: C) usize {
            return f[@backingInt(c)];
        }
    }.get;
    inline for (.{ C.engine, C.game_engine, C.viewport, C.world, C.level, C.world_settings, C.game_instance, C.player, C.controller }) |c| {
        if (get(&found, c) == 0) {
            missing.* = "Engine's " ++ classes[@backingInt(c)];
            return error.MissingClass;
        }
    }
    const engine = ue.findInstance("GameEngine") orelse {
        missing.* = "the game engine (GEngine)";
        return error.NoEngine;
    };
    const off = struct {
        /// `name` can list older names after a `|`, like `PauserPlayerState|Pauser`.
        fn off(u: *const Unreal, class: usize, comptime name: []const u8, m: *[]const u8) !usize {
            var it = std.mem.splitScalar(u8, name, '|');
            while (it.next()) |n| if (u.offsetOf(class, n)) |o| return o;
            m.* = name;
            return error.MissingProperty;
        }
    }.off;
    var self: World = .{
        .ue = ue,
        .engine = engine,
        .off = .{
            .game_viewport = try off(ue, get(&found, .engine), "GameViewport", missing),
            .game_instance = try off(ue, get(&found, .game_engine), "GameInstance", missing),
            .world = try off(ue, get(&found, .viewport), "World", missing),
            .persistent_level = try off(ue, get(&found, .world), "PersistentLevel", missing),
            .world_settings = try off(ue, get(&found, .level), "WorldSettings", missing),
            .time_dilation = try off(ue, get(&found, .world_settings), "TimeDilation", missing),
            .pauser = try off(ue, get(&found, .world_settings), "PauserPlayerState|Pauser", missing),
            .local_players = try off(ue, get(&found, .game_instance), "LocalPlayers", missing),
            .player_controller = try off(ue, get(&found, .player), "PlayerController", missing),
            .player_state = try off(ue, get(&found, .controller), "PlayerState", missing),
            .viewport_console = ue.offsetOf(get(&found, .viewport), "ViewportConsole"),
            .console_class = ue.offsetOf(get(&found, .engine), "ConsoleClass"),
            .console_keys = if (get(&found, .input) != 0) ue.offsetOf(get(&found, .input), "ConsoleKeys") else null,
        },
        .console_class = get(&found, .console),
        .input_settings = get(&found, .input_cdo),
    };
    if (get(&found, .kismet) != 0 and get(&found, .kismet_cdo) != 0) {
        self.console_command = function(ue, get(&found, .kismet), get(&found, .kismet_cdo), "ExecuteConsoleCommand", &.{ "WorldContextObject", "Command", "SpecificPlayer" });
    }
    if (get(&found, .statics) != 0 and get(&found, .statics_cdo) != 0) {
        self.spawn_object = function(ue, get(&found, .statics), get(&found, .statics_cdo), "SpawnObject", &.{ "ObjectClass", "Outer", "ReturnValue" });
    }
    return self;
}

fn function(ue: *const Unreal, class: usize, cdo: usize, name: []const u8, params: []const []const u8) ?Function {
    const f = ue.functionNamed(class, name) orelse return null;
    const size = ue.structSize(f) orelse return null;
    var out: Function = .{ .object = cdo, .function = f, .size = @intCast(size) };
    for (params, 0..) |p, i| out.params[i] = ue.offsetOf(f, p) orelse return null;
    return out;
}

fn at(self: *const World, obj: usize, offset: usize) ?usize {
    return self.ue.mem.ptr(obj + offset);
}

pub fn viewport(self: *const World) ?usize {
    return self.at(self.engine, self.off.game_viewport);
}

/// The world being played, which changes with each level load.
pub fn world(self: *const World) ?usize {
    return self.at(self.viewport() orelse return null, self.off.world);
}

pub fn settings(self: *const World) ?usize {
    const level = self.at(self.world() orelse return null, self.off.persistent_level) orelse return null;
    return self.at(level, self.off.world_settings);
}

/// The first local player's controller.
pub fn playerController(self: *const World) ?usize {
    const instance = self.at(self.engine, self.off.game_instance) orelse return null;
    const players = self.at(instance, self.off.local_players) orelse return null;
    const count = self.ue.mem.read(i32, instance + self.off.local_players + 8) orelse return null;
    if (count < 1) return null;
    const player = self.ue.mem.ptr(players) orelse return null;
    return self.at(player, self.off.player_controller);
}

pub fn playerState(self: *const World) ?usize {
    return self.at(self.playerController() orelse return null, self.off.player_state);
}
