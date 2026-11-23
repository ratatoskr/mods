//! Tells Wraith whether the game's drawing HDR. Unreal draws SDR into 10-bit swap chains too, so the
//! swap chain alone can't say, and Wraith might have missed the game setting its colour space. The
//! game's settings know, so they're asked now and then, which picks up HDR turned on or off in the
//! game's options.

const std = @import("std");
const sdk = @import("wraith_sdk");

const Unreal = @import("ue/Unreal.zig");
const Loop = @import("loop.zig").Loop;

const log = sdk.log.scoped(.unreal);

/// Ticks between asks.
const every = 120;
const max_misses = 5;

pub const Hdr = struct {
    ue: *const Unreal,
    loop: *Loop,
    /// `GameUserSettings.IsHDREnabled`, and where its answer goes.
    function: usize,
    size: usize,
    returns: usize,
    // Game thread only from here
    settings: usize = 0,
    ticks: u32 = 0,
    told: ?bool = null,
    /// Looking for the settings goes through every object, so it stops after a few misses.
    misses: u8 = 0,

    pub fn find(ue: *const Unreal, loop: *Loop, missing: *[]const u8) !Hdr {
        var found: [1]usize = undefined;
        ue.findIn("/Script/Engine", &.{"GameUserSettings"}, &found);
        if (found[0] == 0) {
            missing.* = "GameUserSettings";
            return error.MissingClass;
        }
        const function = ue.functionNamed(found[0], "IsHDREnabled") orelse {
            missing.* = "IsHDREnabled";
            return error.MissingFunction;
        };
        return .{
            .ue = ue,
            .loop = loop,
            .function = function,
            .size = @intCast(ue.structSize(function) orelse return error.MissingFunction),
            .returns = ue.offsetOf(function, "ReturnValue") orelse {
                missing.* = "IsHDREnabled's ReturnValue";
                return error.MissingProperty;
            },
        };
    }

    /// Game thread, once a tick.
    pub fn tick(self: *Hdr) void {
        self.ticks +%= 1;
        if (self.ticks % every != 1) return;
        const on = self.ask() orelse return;
        if (self.told == on) return;
        self.told = on;
        sdk.frame.setColorSpace(if (on) .hdr10 else .srgb);
        log.info("The game's HDR is {s}", .{if (on) "on" else "off"});
    }

    fn ask(self: *Hdr) ?bool {
        // The game makes its settings object as it starts, and could make another
        if (self.settings == 0 or !self.ue.objects.isObject(self.settings)) {
            if (self.misses == max_misses) return null;
            self.settings = self.ue.findInstance("GameUserSettings") orelse {
                self.misses += 1;
                if (self.misses == max_misses) log.info("The game has no settings object, so Wraith can't ask it about HDR", .{});
                return null;
            };
        }
        var params: [16]u8 align(16) = @splat(0);
        if (self.size > params.len or self.returns >= params.len) return null;
        self.loop.call(self.settings, self.function, params[0..self.size]);
        return params[self.returns] != 0;
    }
};
