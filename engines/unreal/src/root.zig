//! Unreal Engine games, UE4 and UE5. Finds the engine's names, objects and class layouts as the
//! game starts, without signatures or tables for each version, and writes every class and struct
//! to a dump in Wraith's folder. Then ticks Wraith on the game thread through `ProcessEvent`, does
//! game speed with the world's time dilation, gives the game a console, hands its camera to Wraith's
//! free camera and its characters to posing, tells Wraith when the game's drawing HDR, and gives
//! the Workbench a Scene panel of the world's actors and a Classes panel.

const std = @import("std");
const sdk = @import("wraith_sdk");

const Mem = @import("ue/Mem.zig");
const Unreal = @import("ue/Unreal.zig");
const World = @import("ue/World.zig");
const dump = @import("ue/dump.zig");
const process_event = @import("ue/process_event.zig");
const Loop = @import("loop.zig").Loop;
const Speed = @import("speed.zig").Speed;
const Console = @import("console.zig").Console;
const Camera = @import("camera.zig").Camera;
const Posing = @import("posing.zig").Posing;
const Meshes = @import("meshes.zig").Meshes;
const Hdr = @import("hdr.zig").Hdr;
const Explorer = @import("explorer.zig").Explorer;
const Service = @import("service.zig").Service;
const schema = @import("schema");

pub const std_options: std.Options = .{ .logFn = sdk.logFn };
pub const panic = sdk.panic;

const log = sdk.log.scoped(.unreal);

pub const Plugin = struct {
    ctx: *sdk.Context = undefined,
    mem: ?Mem = null,
    ue: ?Unreal = null,
    world: ?World = null,
    /// Taken in `start`, so nobody's ticks run on the render thread first.
    ticks: ?sdk.frame.TickDriver = null,
    loop: Loop = .{},
    speed: Speed = .{},
    console: Console = .{},
    camera: Camera = .{},
    meshes: ?Meshes = null,
    posing: ?Posing = null,
    hdr: ?Hdr = null,
    explorer: Explorer = .{},
    /// Set before ticks start, and the explorer's ready then.
    explorer_on: bool = false,
    /// The `Unreal` service, which works once ticks start.
    service: Service = .{},

    pub const services = .{unreal};

    pub fn unreal(self: *Plugin) schema.Unreal {
        return .init(&self.service, sdk.salamander.rt.implement(schema.Unreal, Service));
    }

    pub fn start(self: *Plugin, ctx: *sdk.Context) !void {
        self.ctx = ctx;
        self.ticks = sdk.frame.driveTicks() catch |err| blk: {
            log.warn("Wraith won't let Unreal's game thread tick ({t}), so plugins' ticks stay on the render thread", .{err});
            break :blk null;
        };
        _ = try ctx.onFrame(&self.loop, Loop.frame);
        try ctx.addWindow(&self.console);
        try ctx.menuItem("Console", &self.console.window.open);
        try ctx.spawn(setUp, .{self});
    }

    pub fn stop(self: *Plugin) void {
        self.service.stop();
        // Its panels go first, while ticks still run
        if (self.explorer_on) self.explorer.stop();
        self.explorer_on = false;
        // Puts the game back, on its own thread, while the hook's still in
        self.loop.farewell(self.ctx.io, .{ .context = self, .func = farewell });
        // No more ticks once it's out, and it waits for one in flight
        self.loop.stop();
        self.speed.stop();
        if (self.posing) |*p| p.deinit();
        if (self.meshes) |*m| m.deinit();
        self.handBack();
        if (self.mem) |*m| m.deinit();
    }

    /// Game thread, just before the plugin goes.
    fn farewell(raw: *anyopaque) void {
        const self: *Plugin = @ptrCast(@alignCast(raw));
        if (self.posing) |*p| p.restore();
        self.camera.leave();
    }

    fn handBack(self: *Plugin) void {
        if (self.ticks) |t| t.release();
        self.ticks = null;
    }

    /// Game thread, once a frame.
    fn tick(raw: *anyopaque) void {
        const self: *Plugin = @ptrCast(@alignCast(raw));
        if (self.ticks) |t| t.tick();
        self.speed.apply();
        self.console.tick();
        if (self.camera.tools != null) self.camera.tick();
        if (self.meshes) |*m| m.tick();
        if (self.posing) |*p| p.tick();
        if (self.hdr) |*h| h.tick();
        if (self.explorer_on) self.explorer.tick();
    }

    /// The engine fills in its objects as it boots, so this waits for them.
    fn setUp(self: *Plugin) !void {
        // Nothing would tick otherwise
        errdefer self.handBack();
        const io = self.ctx.io;
        try sdk.frame.toWorker(io);
        self.mem = try Mem.init(self.ctx.allocator);
        const mem = &self.mem.?;
        var data: std.ArrayList([]const usize) = .empty;
        defer data.deinit(self.ctx.allocator);
        try dataSections(self.ctx.allocator, &data);

        const began = std.Io.Clock.awake.now(io);
        log.info("Looking for Unreal's names and objects", .{});
        var missing: []const u8 = "";
        var tries: usize = 0;
        self.ue = while (true) : (tries += 1) {
            const try_began = std.Io.Clock.awake.now(io);
            const result = Unreal.find(mem, data.items, &missing);
            const try_ms = @divTrunc(try_began.durationTo(std.Io.Clock.awake.now(io)).nanoseconds, std.time.ns_per_ms);
            if (result) |found| {
                // Too few and it's still booting, with CoreUObject's bits maybe not all there yet
                if (found.objects.count() > 1000) break found;
                missing = "more than 1000 objects";
            } else |err| if (tries == max_tries) {
                log.err("Can't find {s} ({t}), so there's nothing to do", .{ missing, err });
                return err;
            }
            if (tries % 20 == 0) log.info("Still looking for {s} (a look takes {d}ms)", .{ missing, try_ms });
            try io.sleep(.fromMilliseconds(500), .awake);
            try mem.refresh();
        };
        const ue = &self.ue.?;
        const took = @divTrunc(began.durationTo(std.Io.Clock.awake.now(io)).nanoseconds, std.time.ns_per_ms);

        var version_buf: [64]u8 = undefined;
        const l = ue.layout;
        log.info("{s}: {d} objects, names in {s}, properties as {s}, {s} vectors (found in {d}ms)", .{
            engineVersion(&version_buf) orelse if (l.doubles) "UE5" else "UE4",
            ue.objects.count(),
            if (ue.names.kind == .pool) "a pool (4.23+)" else "an array (before 4.23)",
            if (l.child_properties != null) "FField (4.25+)" else "UProperty (before 4.25)",
            if (l.doubles) "double" else "float",
            took,
        });
        log.debug("Layout: {any}", .{l});

        // The engine object comes a little after the classes
        tries = 0;
        self.world = while (true) : (tries += 1) {
            if (World.find(ue, &missing)) |w| break w else |err| if (tries == max_tries) {
                log.err("Can't find {s} ({t}), so there's no speed or console", .{ missing, err });
                return err;
            }
            if (tries % 20 == 0) log.info("Still looking for {s}", .{missing});
            try io.sleep(.fromMilliseconds(500), .awake);
        };
        const world = &self.world.?;
        const pe = process_event.find(ue) orelse {
            log.err("Can't find ProcessEvent, so there's no game thread, speed or console", .{});
            return error.NoProcessEvent;
        };
        log.info("ProcessEvent at 0x{x}{s}{s}", .{
            pe,
            if (world.console_command == null) ", no ExecuteConsoleCommand" else "",
            if (world.spawn_object == null) ", no SpawnObject" else "",
        });
        self.console.start(world, &self.loop);
        self.speed.start(world, self.ctx.wraith.game());
        if (Camera.find(ue, &missing)) |off| {
            self.camera.start(world, &self.loop, off);
            self.loop.watch(off.modify, &self.camera, Camera.onModify);
        } else |err| log.warn("No free camera, since this Unreal's missing {s}: {t}", .{ missing, err });
        if (Meshes.find(ue, &self.loop, &self.camera, &missing)) |m| {
            self.meshes = m;
            const meshes = &self.meshes.?;
            self.loop.watch(m.off.post_evaluate, meshes, Meshes.onPostEvaluate);
            self.camera.late = .{ .context = meshes, .func = Meshes.lateCallback };
            if (Posing.find(ue, &self.loop, meshes, world, &missing)) |found| {
                if (found) |p| {
                    self.posing = p;
                    meshes.listener = .{ .context = &self.posing.?, .func = Posing.onAnimated };
                }
            } else |err| log.warn("No posing, since this Unreal's missing {s}: {t}", .{ missing, err });
        } else |err| log.warn("No posing, since this Unreal's missing {s}: {t}", .{ missing, err });
        if (Hdr.find(ue, &self.loop, &missing)) |h| {
            self.hdr = h;
        } else |err| log.info("Can't ask the game about HDR, since this Unreal's missing {s}: {t}", .{ missing, err });
        if (self.explorer.start(ue, world, &self.loop, self.camera.tools)) {
            self.explorer_on = true;
        } else |err| log.warn("No Scene or Classes panel: {t}", .{err});
        try self.loop.start(pe, .{ .context = self, .func = tick });
        self.service.start(ue, &self.loop);

        // Gives the game a bit to load more of its classes
        try io.sleep(.fromSeconds(10), .awake);
        self.writeDump() catch |err| log.warn("Couldn't write the dump: {t}", .{err});
    }
    const max_tries = 240;

    fn writeDump(self: *Plugin) !void {
        const ue = &(self.ue orelse return);
        const a = self.ctx.allocator;
        var out: std.Io.Writer.Allocating = .init(a);
        defer out.deinit();
        const counts = try dump.write(ue, &out.writer);

        const info = self.ctx.wraith.game().info();
        const local = try sdk.platform.fs.localAppDataDirAlloc(a);
        defer a.free(local);
        const name = try std.fmt.allocPrint(a, "{s}.txt", .{info.id});
        defer a.free(name);
        const dir = try std.fs.path.join(a, &.{ local, "Wraith", "dumps", "unreal" });
        defer a.free(dir);
        const path = try std.fs.path.join(a, &.{ dir, name });
        defer a.free(path);
        const io = self.ctx.io;
        try std.Io.Dir.cwd().createDirPath(io, dir);
        try std.Io.Dir.cwd().writeFile(io, .{ .sub_path = path, .data = out.written() });
        log.info("Wrote {d} classes and {d} structs to {s}", .{ counts.classes, counts.structs, path });
    }
};

/// The exe's writable data, where the engine's globals are.
fn dataSections(a: std.mem.Allocator, out: *std.ArrayList([]const usize)) !void {
    var it = try sdk.Module.main().sections();
    while (it.next()) |s| {
        if (!s.writable or s.executable or !s.readable) continue;
        const start = std.mem.alignForward(usize, s.start, 8);
        const end = s.start + s.len;
        if (end <= start + 8) continue;
        const words: [*]const usize = @ptrFromInt(start);
        try out.append(a, words[0 .. (end - start) / 8]);
    }
}

/// Like `UE 4.27`, from the build string most exes keep, as text or wide.
fn engineVersion(buf: []u8) ?[]const u8 {
    var it = sdk.Module.main().sections() catch return null;
    while (it.next()) |s| {
        if (s.executable or s.writable or !s.readable) continue;
        const bytes = @as([*]const u8, @ptrFromInt(s.start))[0..s.len];
        inline for (.{ "++UE5+Release-", "++UE4+Release-" }) |marker| {
            if (std.mem.indexOf(u8, bytes, marker)) |i| return versionAt(bytes[i + 2 ..], 1, buf);
            const wide = comptime widen(marker);
            if (std.mem.indexOf(u8, bytes, &wide)) |i| return versionAt(bytes[i + 4 ..], 2, buf);
        }
    }
    return null;
}

fn widen(comptime s: []const u8) [s.len * 2]u8 {
    var out: [s.len * 2]u8 = @splat(0);
    for (s, 0..) |c, i| out[i * 2] = c;
    return out;
}

/// "UE4+Release-4.27" to "UE 4.27", reading every `step`th byte.
fn versionAt(bytes: []const u8, step: usize, buf: []u8) ?[]const u8 {
    const prefix = "UE ";
    @memcpy(buf[0..prefix.len], prefix);
    var n: usize = prefix.len;
    var i: usize = "UE4+Release-".len * step;
    while (i < bytes.len and n < buf.len) : (i += step) {
        const c = bytes[i];
        if (!std.ascii.isDigit(c) and c != '.') break;
        buf[n] = c;
        n += 1;
    }
    return if (n > prefix.len) buf[0..n] else null;
}

comptime {
    sdk.exportPlugin(Plugin);
}

test {
    _ = Mem;
    _ = @import("ue/names.zig");
    _ = @import("ue/objects.zig");
    _ = process_event;
    _ = @import("loop.zig");
    _ = @import("speed.zig");
    _ = @import("camera.zig");
    _ = @import("posing.zig");
    _ = @import("meshes.zig");
    _ = @import("ue/Bones.zig");
    _ = @import("hdr.zig");
    _ = @import("explorer.zig");
    _ = @import("service.zig");
}

test "version from the build string" {
    var buf: [32]u8 = undefined;
    try std.testing.expectEqualStrings("UE 4.27", versionAt("UE4+Release-4.27-CL-0", 1, &buf).?);
    const wide = widen("UE5+Release-5.3");
    try std.testing.expectEqualStrings("UE 5.3", versionAt(&wide, 2, &buf).?);
}
