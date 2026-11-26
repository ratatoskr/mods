//! Wraith's ticks on FFXIV's main thread, from `Framework.Tick`, the same place Dalamud's
//! `Framework.Update` comes from. So plugins' `onTick` runs where the game's own update does.

const sdk = @import("wraith_sdk");
const schema = @import("schema");

const Framework = schema.Client.System.Framework.Framework;
const TickHook = sdk.hooks.FnHook(Framework.Fns.tick);

const log = sdk.log.scoped(.plugin);

pub const Tick = struct {
    driver: ?sdk.Lease = null,
    hook: TickHook = undefined,

    /// In `start`, before anything subscribes. Without the hook, ticks stay on the render thread.
    pub fn start(self: *Tick) void {
        self.driver = sdk.threads.claimTicks(.none) catch |err| {
            log.warn("Wraith won't let FFXIV's main thread tick ({t}), so plugins' ticks stay on the render thread", .{err});
            return;
        };
        self.hookTick() catch |err| {
            log.err("Can't find Framework's tick ({t}), so plugins' ticks stay on the render thread", .{err});
            // Ticks wait for the first one, which would never come
            self.stop();
        };
    }

    fn hookTick(self: *Tick) !void {
        // A virtual, so it's the function in its vtable slot
        const slot = try Framework.addresses.tick();
        const target = try sdk.Address.at(slot).deref().unwrap();
        self.hook = try sdk.hooks.createFnWith(Framework.Fns.tick, target, detour, self, .{ .enabled = true });
    }

    /// Its `tick` does nothing once it's let go, so the game can still call the hook.
    pub fn stop(self: *Tick) void {
        if (self.driver) |d| d.release();
        self.driver = null;
    }

    fn detour(self: *Tick, hook: TickHook, framework: *Framework) bool {
        if (self.driver != null) sdk.threads.tick();
        return hook.original()(framework);
    }
};
