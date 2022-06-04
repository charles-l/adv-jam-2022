const std = @import("std");
const assert = std.debug.assert;
const print = std.debug.print;
const screen_width = 800;
const screen_height = 600;

const c = @import("c.zig").c;

const m = @import("raymath.zig");

const block_width = 32;
const block_height = block_width / 2;
const block_depth = block_height / 2;

const view_size = 16;

const SpriteSheet = struct {
    texture: c.Texture,
    frames: usize,

    const Self = @This();
    fn width(self: Self) f32 {
        return @intToFloat(f32, self.texture.width) / @intToFloat(f32, self.frames);
    }

    fn frameRect(self: Self, i: usize) c.Rectangle {
        return c.Rectangle{
            .x = self.width() * @intToFloat(f32, i),
            .y = 0,
            .width = self.width(),
            .height = @intToFloat(f32, self.texture.height),
        };
    }

    /// rotation is in degrees
    fn drawFrameEx(self: Self, pos: m.Vector2, rotation: f32, i: usize, alpha: f32) void {
        c.DrawTexturePro(
            self.texture,
            self.frameRect(i),
            c.Rectangle{
                .x = pos.x,
                .y = pos.y,
                .width = self.width(),
                .height = @intToFloat(f32, self.texture.height),
            },
            m.Vector2{
                .x = self.width() / 2,
                .y = @intToFloat(f32, self.texture.height),
            },
            rotation,
            c.Color{ .r = 255, .g = 255, .b = 255, .a = @floatToInt(u8, 255 * alpha) },
        );
    }

    fn drawFrame(self: Self, pos: m.Vector2, i: usize) void {
        self.drawFrameEx(pos, 0, i, 1);
    }

    fn drawFrameIso(self: Self, pos: m.Vector2i, i: usize) void {
        self.drawFrameEx(xyToIso(.{
            .x = @mod(pos.x, view_size),
            .y = @mod(pos.y, view_size),
        }).toVector2(), 0, i, 1);
    }
};

pub fn xyToIso(v: m.Vector2i) m.Vector2i {
    return .{
        .x = 400 + (v.x - v.y) * (block_width / 2),
        .y = 200 + (v.x + v.y) * (block_height / 2),
    };
}

pub fn drawTexIso(tex: c.Texture, x: i32, y: i32) void {
    const v = xyToIso(.{ .x = x, .y = y });
    c.DrawTexture(tex, v.x - @divTrunc(tex.width, 2), v.y - tex.height + block_height / 2, c.WHITE);
    //c.DrawCircle(xx, yy, 2, c.PURPLE);
}

const Map = struct {
    const TileType = enum {
        nothing,
        floor,
    };

    const start_marker = c.Color{ .r = 255, .g = 0, .b = 0, .a = 255 };
    const floor_marker = c.Color{ .r = 0, .g = 0, .b = 0, .a = 255 };

    pixels: []c.Color,
    width: usize,
    height: usize,

    const Self = @This();

    fn getTile(self: Self, pos: m.Vector2i) TileType {
        const pixel = self.pixels[
            @intCast(usize, pos.y) *
                self.width +
                @intCast(usize, pos.x)
        ];

        if (std.meta.eql(pixel, floor_marker) or std.meta.eql(pixel, start_marker)) {
            return .floor;
        } else {
            return .nothing;
        }
    }
};

pub fn main() void {
    c.InitWindow(screen_width, screen_height, "game");
    c.SetTargetFPS(60);

    const iso_floor = c.LoadTexture("iso_floor.png");
    const hero = SpriteSheet{ .texture = c.LoadTexture("hero.png"), .frames = 4 };
    const map_image = c.LoadImage("map1.png");
    const map = Map{ .pixels = c.LoadImageColors(map_image)[0..@intCast(usize, map_image.width * map_image.height)], .width = @intCast(usize, map_image.width), .height = @intCast(usize, map_image.height) };
    defer c.UnloadImageColors(map.pixels.ptr);

    const start = lbl: {
        for (map.pixels) |p, i| {
            if (std.meta.eql(p, Map.start_marker)) {
                break :lbl m.Vector2i{ .x = @intCast(i32, @mod(i, map.width)), .y = @intCast(i32, @divTrunc(i, map.width)) };
            }
        }
        // failed to find start
        assert(false);
        break :lbl m.Vector2i{ .x = 0, .y = 0 };
    };
    print("start {}\n", .{start});

    var state = .{
        .hero = .{
            .pos = m.Vector2i{ .x = 0, .y = 0 },
            //.pos = start, <- BUG: segfaults
        },
    };

    state.hero.pos = start;

    while (!c.WindowShouldClose()) {
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.GRAY);

        { // draw map chunk
            var map_chunk: [view_size][view_size]Map.TileType = undefined;

            {
                const chunk_off_x = @intCast(usize, @divTrunc(state.hero.pos.x, view_size)) * view_size;
                const chunk_off_y = @intCast(usize, @divTrunc(state.hero.pos.y, view_size)) * view_size;

                var x: usize = 0;
                while (x < view_size) : (x += 1) {
                    var y: usize = 0;
                    while (y < view_size) : (y += 1) {
                        map_chunk[y][x] = map.getTile(.{ .x = @intCast(i32, chunk_off_x + x), .y = @intCast(i32, chunk_off_y + y) });
                    }
                }
            }

            for (map_chunk) |row, y| {
                for (row) |tile, x| {
                    if (tile == .floor) {
                        drawTexIso(iso_floor, @intCast(i32, x), @intCast(i32, y));
                    }
                }
            }
        }

        // {
        //     var x: i32 = 0;
        //     while (x < view_size) : (x += 1) {
        //         const y = 0;
        //         drawTexIso(iso_tile, x, y, 1);
        //     }
        // }
        hero.drawFrameIso(state.hero.pos, 0);

        {
            assert(map.getTile(state.hero.pos) == .floor);
            const orig_pos = state.hero.pos;

            if (c.IsKeyPressed(c.KEY_W)) {
                state.hero.pos.x -= 1;
            }
            if (c.IsKeyPressed(c.KEY_S)) {
                state.hero.pos.x += 1;
            }
            if (c.IsKeyPressed(c.KEY_A)) {
                state.hero.pos.y += 1;
            }
            if (c.IsKeyPressed(c.KEY_D)) {
                state.hero.pos.y -= 1;
            }

            if (map.getTile(state.hero.pos) != .floor) {
                state.hero.pos = orig_pos;
            }

            assert(map.getTile(state.hero.pos) == .floor);
        }
    }

    c.CloseWindow();
}
