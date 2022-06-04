const std = @import("std");
const assert = std.debug.assert;
const print = std.debug.print;
const screen_width = 1200;
const screen_height = 700;

const eql = std.meta.eql;

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
    fn drawFrameEx(self: Self, pos: m.Vector2, rotation: f32, i: usize, alpha: f32, fliph: bool) void {
        var r = self.frameRect(i);
        if (fliph) {
            r.width = -r.width;
        }
        c.DrawTexturePro(
            self.texture,
            r,
            c.Rectangle{
                .x = pos.x,
                .y = pos.y,
                .width = self.width(),
                .height = @intToFloat(f32, self.texture.height),
            },
            m.Vector2{
                .x = self.width() / 2 - block_width / 2,
                .y = @intToFloat(f32, self.texture.height),
            },
            rotation,
            c.Color{ .r = 255, .g = 255, .b = 255, .a = @floatToInt(u8, 255 * alpha) },
        );
    }

    fn drawFrameIso(self: Self, pos: m.Vector2, i: usize, fliph: bool) void {
        self.drawFrameEx(xyToIso(.{
            .x = @mod(pos.x, view_size),
            .y = @mod(pos.y, view_size),
        }), 0, i, 1, fliph);
    }
};

pub fn v2i(v: m.Vector2) m.Vector2i {
    return m.Vector2i{ .x = @floatToInt(i32, v.x), .y = @floatToInt(i32, v.y) };
}

pub fn xyToIso(v: m.Vector2) m.Vector2 {
    return .{ .x = (v.x - v.y) * block_height, .y = ((v.x + v.y) / 2) * block_height };
}

pub fn isoToXy(v: m.Vector2) m.Vector2 {
    var v1 = m.Vector2{ .x = v.x / block_height, .y = v.y / block_height };
    return .{
        .x = (2 * v1.y + v1.x) / 2,
        .y = (2 * v1.y - v1.x) / 2,
    };
}

pub fn drawGridTile(tex: c.Texture, x: i32, y: i32) void {
    drawGridTileTinted(tex, x, y, c.WHITE);
}

pub fn drawGridTileTinted(tex: c.Texture, x: i32, y: i32, color: c.Color) void {
    var v = xyToIso(.{ .x = @intToFloat(f32, x), .y = @intToFloat(f32, y) });
    v.y += block_height / 2 - @intToFloat(f32, tex.height);
    c.DrawTextureV(tex, v, color);
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
        assert(0 <= pos.x);
        assert(pos.x < self.width);
        assert(0 <= pos.y);
        assert(pos.y < self.height);
        const pixel = self.pixels[
            @intCast(usize, pos.y) *
                self.width +
                @intCast(usize, pos.x)
        ];

        if (eql(pixel, floor_marker) or eql(pixel, start_marker)) {
            return .floor;
        } else {
            return .nothing;
        }
    }
};

var camera = c.Camera2D{
    .offset = .{ .x = screen_width / 2, .y = screen_height / 2 - 160 },
    .target = .{ .x = 0, .y = 0 },
    .rotation = 0,
    .zoom = 2,
};

fn walkToGoal(pos: *m.Vector2, goal: m.Vector2, hero: SpriteSheet) void {
    var t: f32 = 0;
    var last_pos = pos.*;
    while (true) {
        suspend {}
        hero.drawFrameIso(pos.*, @floatToInt(usize, @mod(t * 8, 4)), last_pos.x - pos.x < 0);
        t += c.GetFrameTime();

        {
            const diff = m.Vector2Subtract(goal, pos.*);
            last_pos = pos.*;
            if (m.Vector2Length(diff) > 0.1) {
                pos.* = m.Vector2Add(pos.*, m.Vector2Scale(diff, 1 / (m.Vector2Length(diff) * 10)));
            } else {
                pos.* = goal;
                break;
            }
        }
    }
    hero_movement = null;
}

var hero_movement: ?anyframe = null;

pub fn main() void {
    c.InitWindow(screen_width, screen_height, "game");
    c.SetTargetFPS(60);

    const iso_floor = c.LoadTexture("iso_floor.png");
    //const iso_cube = c.LoadTexture("iso_cube.png");
    const hero = SpriteSheet{ .texture = c.LoadTexture("hero.png"), .frames = 4 };
    const map_image = c.LoadImage("map1.png");
    const map = Map{ .pixels = c.LoadImageColors(map_image)[0..@intCast(usize, map_image.width * map_image.height)], .width = @intCast(usize, map_image.width), .height = @intCast(usize, map_image.height) };
    defer c.UnloadImageColors(map.pixels.ptr);

    const start = lbl: {
        for (map.pixels) |p, i| {
            if (eql(p, Map.start_marker)) {
                break :lbl m.Vector2{ .x = @intToFloat(f32, @mod(i, map.width)), .y = @intToFloat(f32, @divTrunc(i, map.width)) };
            }
        }
        // failed to find start
        assert(false);
        break :lbl m.Vector2{ .x = 0, .y = 0 };
    };

    var state = .{
        .hero = .{
            .pos = m.Vector2{ .x = 0, .y = 0 },
            .goal = m.Vector2i{ .x = 0, .y = 0 },
            //.pos = start, <- BUG: segfaults
        },
    };

    state.hero.pos = start;
    state.hero.goal = v2i(start);

    while (!c.WindowShouldClose()) {
        c.BeginDrawing();
        defer c.EndDrawing();

        c.BeginMode2D(camera);

        c.ClearBackground(c.GRAY);

        const chunk_off_x = @floatToInt(usize, state.hero.pos.x / view_size) * view_size;
        const chunk_off_y = @floatToInt(usize, state.hero.pos.y / view_size) * view_size;

        { // draw map chunk
            var map_chunk: [view_size][view_size]Map.TileType = undefined;

            {
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
                        drawGridTile(iso_floor, @intCast(i32, x), @intCast(i32, y));
                    }
                }
            }

            {
                var i: i32 = -1;
                while (i < view_size) : (i += 1) {
                    for ([_]m.Vector2i{
                        m.Vector2i{ .x = i, .y = -1 },
                        m.Vector2i{ .x = -1, .y = i },
                        m.Vector2i{ .x = i, .y = view_size },
                        m.Vector2i{ .x = view_size, .y = i },
                    }) |v| {
                        const gx = v.x + @intCast(i32, chunk_off_x);
                        const gy = v.y + @intCast(i32, chunk_off_y);
                        if (0 <= gx and gx < map.width and 0 <= gy and gy < map.height) {
                            if (map.getTile(.{ .x = gx, .y = gy }) == .floor) {
                                drawGridTileTinted(iso_floor, v.x, v.y, c.GRAY);
                            }
                        }
                    }
                }
            }
        }

        {
            assert(map.getTile(v2i(state.hero.pos)) == .floor);
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

            if (map.getTile(v2i(state.hero.pos)) != .floor) {
                state.hero.pos = orig_pos;
            }

            assert(map.getTile(v2i(state.hero.pos)) == .floor);
        }

        if (hero_movement) |frame| {
            resume frame;
        } else {
            hero.drawFrameIso(state.hero.pos, 0, false);
        }

        if (c.IsMouseButtonReleased(c.MOUSE_BUTTON_LEFT)) {
            const v = c.GetScreenToWorld2D(c.GetMousePosition(), camera);
            const p = m.Vector2Add(isoToXy(v), .{ .x = @intToFloat(f32, chunk_off_x), .y = @intToFloat(f32, chunk_off_y) + 1 });
            state.hero.goal = v2i(p);

            hero_movement = &async walkToGoal(&state.hero.pos, state.hero.goal.toVector2(), hero);

            const global_goal = state.hero.goal.toVector2();
            c.DrawCircleV(xyToIso(.{ .x = @mod(global_goal.x, view_size), .y = @mod(global_goal.y, view_size) }), 3, c.GREEN);
        }

        c.EndMode2D();
    }

    c.CloseWindow();
}
