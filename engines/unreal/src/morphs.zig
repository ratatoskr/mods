//! A character's blend shapes, morph targets as Unreal has them, for posing. Their names come from
//! the skeletal mesh of each of its meshes, the one being animated and the ones that follow it, like
//! a face on a body. What the game has one at is the animation's curve of the same name. Posing's
//! edits go on through the mesh's own `SetMorphTarget`, which the engine puts over the animation's,
//! and come off the same way, so the animation has it back.

const std = @import("std");
const sdk = @import("wraith_sdk");
const W = sdk.api.wraith;

const Unreal = @import("ue/Unreal.zig");
const FName = Unreal.FName;
const Loop = @import("loop.zig").Loop;

pub const Offsets = struct {
    /// `SkinnedMeshComponent.SkeletalMesh`, or `SkinnedAsset` from UE5.1.
    skeletal_mesh: usize,
    /// `SkeletalMesh.MorphTargets`.
    morph_targets: usize,
    /// `SkeletalMeshComponent.SetMorphTarget`.
    set: Unreal.Call,
    /// `AnimInstance.GetCurveValue`.
    curve: Unreal.Call,
};

/// One morph target, on the mesh that has it, and what posing's put it at.
pub const Shape = struct {
    component: usize,
    /// Its slot in the object array, to tell it's still there without reading it.
    slot: u32,
    name: FName,
    set: ?f32 = null,
};

pub const Morphs = struct {
    ue: *const Unreal,
    loop: *Loop,
    off: Offsets,

    pub fn find(ue: *const Unreal, loop: *Loop, missing: *[]const u8) !Morphs {
        const names = [_][]const u8{ "SkinnedMeshComponent", "SkeletalMeshComponent", "SkeletalMesh", "AnimInstance" };
        var found: [names.len]usize = undefined;
        ue.findIn("/Script/Engine", &names, &found);
        for (names, found) |n, f| if (f == 0) {
            missing.* = n;
            return error.MissingClass;
        };
        const skinned, const skeletal, const mesh, const anim = found;
        return .{
            .ue = ue,
            .loop = loop,
            .off = .{
                .skeletal_mesh = ue.offsetOf(skinned, "SkeletalMesh") orelse ue.offsetOf(skinned, "SkinnedAsset") orelse {
                    missing.* = "SkinnedMeshComponent's SkeletalMesh";
                    return error.MissingProperty;
                },
                .morph_targets = ue.offsetOf(mesh, "MorphTargets") orelse {
                    missing.* = "MorphTargets";
                    return error.MissingProperty;
                },
                .set = try ue.callOf(skeletal, "SetMorphTarget", &.{ "MorphTargetName", "Value", "bRemoveZeroWeight" }, missing),
                .curve = try ue.callOf(anim, "GetCurveValue", &.{ "CurveName", "ReturnValue" }, missing),
            },
        };
    }

    /// Every morph target on `components`' meshes, with a name and mesh for posing. Game thread
    /// only, with every one of them live, so their meshes and morph targets are too, and it's all
    /// read plainly.
    pub fn collect(self: *Morphs, a: std.mem.Allocator, components: []const usize, shapes: *std.ArrayList(Shape), list: *std.ArrayList(W.Posing.Shape)) !void {
        const mem = self.ue.mem;
        var buf: [256]u8 = undefined;
        for (components) |c| {
            const asset = mem.live(usize, c + self.off.skeletal_mesh);
            if (asset == 0) continue;
            const header = mem.live(Unreal.TArray, asset + self.off.morph_targets);
            const count: u32 = @bitCast(header.num);
            if (header.data == 0 or header.num <= 0) continue;
            const mesh = try a.dupe(u8, self.ue.nameOfLive(asset, &buf) orelse "?");
            for (0..count) |i| {
                const target = mem.live(usize, header.data + i * @sizeOf(usize));
                if (target == 0) continue;
                const name = self.ue.nameFrom(@as([*]const u8, @ptrFromInt(target + Unreal.object.name))[0..self.ue.name_size]);
                const text = self.ue.nameText(name, &buf) orelse continue;
                try shapes.append(a, .{ .component = c, .slot = self.ue.objects.slotOf(c), .name = name });
                try list.append(a, .{ .name = try a.dupe(u8, text), .mesh = mesh });
            }
        }
    }

    /// What `anim_instance`'s animation has a morph target at.
    pub fn weight(self: *Morphs, anim_instance: usize, name: FName) f32 {
        var p: [32]u8 align(16) = @splat(0);
        const c = self.off.curve;
        if (c.size > p.len) return 0;
        self.ue.putName(p[c.params[0]..], name);
        self.loop.call(anim_instance, c.function, p[0..c.size]);
        return std.mem.bytesToValue(f32, p[c.params[1]..][0..4]);
    }

    /// Puts a morph target at `value` over the animation's, or with `value` null hands it back.
    pub fn set(self: *Morphs, shape: *Shape, value: ?f32) void {
        if (shape.set == value) return;
        shape.set = value;
        var p: [32]u8 align(16) = @splat(0);
        const c = self.off.set;
        if (c.size > p.len) return;
        self.ue.putName(p[c.params[0]..], shape.name);
        std.mem.writeInt(u32, p[c.params[1]..][0..4], @bitCast(value orelse 0), .little);
        p[c.params[2]] = @intFromBool(value == null);
        self.loop.call(shape.component, c.function, p[0..c.size]);
    }
};
