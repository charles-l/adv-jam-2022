import pyray as rl
import heapq
import numpy as np
from dataclasses import dataclass
from enum import IntEnum
from typing import Tuple, List, Optional, Dict, TypeVar
import math

T = TypeVar("T")


def unwrap_optional(x: Optional[T]) -> T:
    assert x is not None
    return x


DrawCall = Tuple[rl.Texture, rl.Rectangle, rl.Rectangle, rl.Vector2, float, rl.Color]
Vector2i = Tuple[int, int]


@dataclass(slots=True)
class V:
    x: float
    y: float

    def __eq__(self, other):
        return self.x == other[0] and self.y == other[1]

    def __getitem__(self, i):
        return (self.x, self.y)[i]

    def __add__(self, other):
        return V(self.x + other[0], self.y + other[1])

    def __sub__(self, other):
        return V(self.x - other[0], self.y - other[1])

    def __mul__(self, scalar):
        return V(self.x * scalar, self.y * scalar)

    def __truediv__(self, scalar):
        return V(self.x / scalar, self.y / scalar)

    def __floordiv__(self, scalar):
        return V(self.x // scalar, self.y // scalar)

    def __mod__(self, scalar):
        return V(self.x % scalar, self.y % scalar)

    def __hash__(self):
        return hash((self.x, self.y))

    def floor(self):
        return V(int(self.x), int(self.y))

    def length(self):
        return math.sqrt(self.x**2 + self.y**2)


@dataclass
class Hero:
    pos: V
    goal: Vector2i


@dataclass
class State:
    hero: Hero


@dataclass
class SpriteSheet:
    texture: rl.Texture
    frames: int

    @property
    def width(self):
        return self.texture.width / self.frames

    def rect(self, frame_i: int) -> rl.Rectangle:
        return rl.Rectangle(self.width * frame_i, 0, self.width, self.texture.height)

    def draw_frame_iso(self, pos: V, i, fliph: bool) -> DrawCall:
        r = self.rect(int(i))
        if fliph:
            r.width = -r.width
        return (
            self.texture,
            r,
            rl.Rectangle(
                *xy_to_iso((pos.x % VIEW_SIZE, pos.y % VIEW_SIZE)),
                self.width,
                self.texture.height,
            ),
            rl.Vector2(self.width / 2 - BLOCK_WIDTH / 2, self.texture.height),
            0,
            rl.WHITE,
        )

    def draw_frame_iso_tile(self, pos: Vector2i, i) -> DrawCall:
        r = self.rect(int(i))
        return (
            self.texture,
            r,
            rl.Rectangle(
                *xy_to_iso((pos[0] % VIEW_SIZE, pos[1] % VIEW_SIZE)),
                self.width,
                self.texture.height,
            ),
            (self.width / 2 - BLOCK_WIDTH / 2, self.texture.height - BLOCK_HEIGHT / 2),
            0,
            rl.WHITE,
        )


SCREEN_WIDTH = 1200
SCREEN_HEIGHT = 700
BLOCK_WIDTH = 32
BLOCK_HEIGHT = BLOCK_WIDTH // 2
VIEW_SIZE = 16

rl.init_window(SCREEN_WIDTH, SCREEN_HEIGHT, "game")
rl.set_target_fps(60)


class TileType(IntEnum):
    NONE = -1
    FLOOR = 0
    START = 1
    FIRE = 2


tile_type = {
    (255, 0, 255, 255): TileType.START,
    (255, 0, 0, 255): TileType.FIRE,
    (0, 0, 0, 255): TileType.FLOOR,
}


map_img = rl.load_image("map1.png")
map_pixels = rl.load_image_colors(map_img)
maparr = np.array(
    [
        tile_type.get(
            (map_pixels[i].r, map_pixels[i].g, map_pixels[i].b, map_pixels[i].a),
            TileType.NONE,
        )
        for i in range(map_img.width * map_img.height)
    ],
    dtype="int8",
).reshape((map_img.height, map_img.width))
(y,), (x,) = np.where(maparr == TileType.START)
start = (x, y)
maparr[y][x] = TileType.FLOOR
rl.unload_image_colors(map_pixels)


def map_tile(x, y):
    if 0 <= x < map_img.width and 0 <= y < map_img.height:
        return maparr[y][x]
    return TileType.NONE


def xy_to_iso(pos):
    return V((pos[0] - pos[1]) * BLOCK_HEIGHT, ((pos[0] + pos[1]) / 2) * BLOCK_HEIGHT)


def iso_to_xy(v):
    v1 = V(v.x / BLOCK_HEIGHT, v.y / BLOCK_HEIGHT)
    return V((2 * v1.y + v1.x) / 2, (2 * v1.y - v1.x) / 2 + 1)


def iso_mouse_pos(state) -> V:
    chunk_offset = (state.hero.pos // VIEW_SIZE) * VIEW_SIZE

    p = rl.get_screen_to_world_2d(rl.get_mouse_position(), camera)
    return iso_to_xy(p) + chunk_offset


def draw_grid_tile(tex: rl.Texture, pos: Tuple[int, int], color=rl.WHITE) -> DrawCall:
    v = xy_to_iso(pos)
    v = (v[0], v[1] + BLOCK_HEIGHT / 2 - tex.height)
    return (
        tex,
        rl.Rectangle(0, 0, tex.width, tex.height),
        rl.Rectangle(v[0], v[1], tex.width, tex.height),
        (0, 0),
        0,
        color,
    )


def highlight_tile(tile):
    TIME = 0.4
    start = rl.get_time()
    while (diff := rl.get_time() - start) < TIME:
        p = xy_to_iso(tile % VIEW_SIZE)
        poly = [
            p,
            p + V(BLOCK_WIDTH / 2, -BLOCK_HEIGHT / 2),
            p + V(BLOCK_WIDTH, 0),
            p + V(BLOCK_WIDTH / 2, BLOCK_HEIGHT / 2),
            p,
        ]
        rl.draw_line_strip(
            [rl.Vector2(*x) for x in poly],
            len(poly),
            rl.fade(rl.YELLOW, 1 - (diff / TIME)),
        )
        yield


def walk_path(maparr, hero, goal):
    path = find_path(hero.pos.floor(), goal)
    if not path:
        return

    t = 0
    last_pos = hero.pos
    while path:
        draw_calls.append(
            hero_sprite.draw_frame_iso(
                hero.pos, (t * 8) % 4, xy_to_iso(hero.pos).x - xy_to_iso(last_pos).x > 0
            )
        )
        yield

        t += rl.get_frame_time()

        last_pos = hero.pos
        diff = V(*path[0]) - hero.pos
        if diff.length() > 0.1:
            hero.pos += diff / (diff.length() * 10)
        else:
            hero.pos = V(*path.pop(0))


def find_path(start, goal) -> Optional[List[Tuple[int, int]]]:
    q: List[Tuple[float, Vector2i]] = [(0, start)]

    came_from: Dict[Vector2i, Optional[Vector2i]] = {}
    cost_so_far: Dict[Vector2i, float] = {}

    came_from[start] = None
    cost_so_far[start] = 0

    while q:
        _, current = heapq.heappop(q)
        if current == goal:
            break

        neighbors = [
            (current[0] - 1, current[1]),
            (current[0], current[1] - 1),
            (current[0] + 1, current[1]),
            (current[0], current[1] + 1),
        ]

        for n in neighbors:
            if map_tile(*n) == TileType.FLOOR:
                new_cost = cost_so_far[current] + 1
                if n not in cost_so_far or new_cost < cost_so_far[n]:
                    cost_so_far[n] = new_cost
                    heapq.heappush(q, (new_cost, n))
                    came_from[n] = current

    if goal not in came_from:
        return None

    path = []
    current = goal
    while current != start:
        path.append(current)
        current = unwrap_optional(came_from[current])

    path.reverse()
    return path


assert start is not None
hero_sprite = SpriteSheet(rl.load_texture("hero.png"), 4)
fire_tile = SpriteSheet(rl.load_texture("floor_fire.png"), 5)
iso_floor = rl.load_texture("iso_floor.png")

# MAIN

draw_calls: List[DrawCall] = []
state = State(Hero(V(*start), start))

# TODO: look at updating makeStructHelper to allow kwargs along with positional args.
camera = rl.Camera2D(
    (SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 - 160),  # offset
    (0, 0),  # target
    0,  # rotation
    2,  # zoom
)

hero_action = None
ui_coros = []

while not rl.window_should_close():
    chunk_offset = (state.hero.pos // VIEW_SIZE) * VIEW_SIZE

    # logic
    if rl.is_key_pressed(rl.KEY_W):
        state.hero.pos += V(0, 1)
    if rl.is_key_pressed(rl.KEY_S):
        state.hero.pos -= V(0, 1)
    if rl.is_key_pressed(rl.KEY_A):
        state.hero.pos += V(1, 0)
    if rl.is_key_pressed(rl.KEY_D):
        state.hero.pos -= V(1, 0)

    if rl.is_mouse_button_released(rl.MOUSE_BUTTON_LEFT):
        p = iso_mouse_pos(state)

        if find_path(state.hero.pos.floor(), p.floor()) is not None:
            ui_coros.append(highlight_tile(p.floor()))

        hero_action = walk_path(maparr, state.hero, p.floor())

    rl.begin_drawing()
    rl.clear_background(rl.GRAY)

    # draw map chunk
    def get_chunk(pos):
        x, y = pos
        assert chunk_offset[0] <= x < chunk_offset[0] + VIEW_SIZE
        assert chunk_offset[1] <= y < chunk_offset[1] + VIEW_SIZE
        return x % VIEW_SIZE, y % VIEW_SIZE

    for y in range(VIEW_SIZE):
        gy = int(y + chunk_offset[1])
        for x in range(VIEW_SIZE):
            gx = int(x + chunk_offset[0])
            if maparr[gy][gx] == TileType.FLOOR:
                draw_calls.append(draw_grid_tile(iso_floor, (x, y)))
            if maparr[gy][gx] == TileType.FIRE:
                draw_calls.append(
                    fire_tile.draw_frame_iso_tile(
                        (x, y), int((rl.get_time() % 0.5) / 0.1)
                    )
                )

    if hero_action is None or next(hero_action, "complete") == "complete":
        draw_calls.append(hero_sprite.draw_frame_iso(state.hero.pos, 0, False))

    draw_calls.sort(key=lambda x: x[2].y)

    rl.begin_mode_2d(camera)

    for args in draw_calls:
        rl.draw_texture_pro(*args)

    for coro in ui_coros:
        try:
            next(coro)
        except StopIteration:
            ui_coros.remove(coro)

    rl.end_mode_2d()

    draw_calls.clear()

    rl.draw_fps(10, 10)

    rl.end_drawing()

rl.close_window()
