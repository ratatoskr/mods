//! Who wants a call on Unity's main thread each frame, through the `Unity` service. Anyone can
//! subscribe or cancel from any thread, but only the main thread calls them, frees them, and drops
//! ones whose plugin's gone.

const std = @import("std");
const sdk = @import("wraith_sdk");
const schema = @import("schema");

const log = sdk.log.scoped(.unity);
const allocator = std.heap.smp_allocator;

/// More than any game needs, and keeps a frame's copy on the stack.
const max = 64;

pub const Subscriber = struct {
    handler: schema.UnityFrame,
    cancelled: sdk.atomic.Value(bool) = .init(false),

    /// `UnitySubscription`. Freed on the main thread, at its next frame.
    pub fn cancel(self: *Subscriber) void {
        self.cancelled.store(true, .release);
    }
};

pub const Frames = struct {
    lock: sdk.sync.Mutex = .{},
    list: std.ArrayList(*Subscriber) = .empty,

    /// Null if there are too many, and `handler`'s let go.
    pub fn subscribe(self: *Frames, handler: schema.UnityFrame) ?*Subscriber {
        const s = allocator.create(Subscriber) catch {
            handler.release();
            return null;
        };
        s.* = .{ .handler = handler };
        self.lock.lock() catch {
            allocator.destroy(s);
            handler.release();
            return null;
        };
        defer self.lock.unlock();
        if (self.list.items.len == max) {
            log.warn("More than {d} plugins want Unity's frames, so the newest misses out", .{max});
        } else if (self.list.append(allocator, s)) |_| return s else |_| {}
        allocator.destroy(s);
        handler.release();
        return null;
    }

    /// Main thread. Calls them outside the lock, so they can subscribe or cancel as they go.
    pub fn fire(self: *Frames) void {
        var now: [max]*Subscriber = undefined;
        const n = blk: {
            // The main thread isn't a task, so this waits rather than failing
            self.lock.lock() catch return;
            defer self.lock.unlock();
            @memcpy(now[0..self.list.items.len], self.list.items);
            break :blk self.list.items.len;
        };
        var any_done = false;
        for (now[0..n]) |s| {
            if (s.cancelled.load(.acquire)) {
                any_done = true;
                continue;
            }
            s.handler.invoke(.{}) catch |err| switch (err) {
                // Its plugin's unloaded
                error.Gone => {
                    s.cancel();
                    any_done = true;
                },
                else => {},
            };
        }
        if (any_done) self.sweep();
    }

    /// Main thread. Frees the cancelled ones, which nothing else holds now.
    fn sweep(self: *Frames) void {
        self.lock.lock() catch return;
        defer self.lock.unlock();
        var i: usize = 0;
        while (i < self.list.items.len) {
            const s = self.list.items[i];
            if (!s.cancelled.load(.acquire)) {
                i += 1;
                continue;
            }
            _ = self.list.orderedRemove(i);
            s.handler.release();
            allocator.destroy(s);
        }
    }

    pub fn deinit(self: *Frames) void {
        self.lock.lock() catch return;
        defer self.lock.unlock();
        for (self.list.items) |s| {
            s.handler.release();
            allocator.destroy(s);
        }
        self.list.deinit(allocator);
        self.list = .empty;
    }
};
