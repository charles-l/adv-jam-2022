import pyray as rl
import heapq
import numpy as np
from dataclasses import dataclass, field
from enum import IntEnum, auto
from typing import Tuple, List, Optional, Dict, TypeVar, NewType, Union
import math

T = TypeVar("T")


def unwrap_optional(x: Optional[T]) -> T:
    assert x is not None
    return x


DrawCall = Tuple[rl.Texture, rl.Rectangle, rl.Rectangle, rl.Vector2, float, rl.Color]


@dataclass(slots=True)
class V2:
    x: float
    y: float

    def __eq__(self, other):
        return self.x == other[0] and self.y == other[1]

    def __lt__(self, other):
        return (self[0], self[1]) < (other[0], other[1])

    def __getitem__(self, i: int):
        return (self.x, self.y)[i]

    def __add__(self, other: "VecType"):
        return V2(self.x + other[0], self.y + other[1])

    def __sub__(self, other: "VecType"):
        return V2(self.x - other[0], self.y - other[1])

    def __mul__(self, scalar: float):
        return V2(self.x * scalar, self.y * scalar)

    def __truediv__(self, scalar: float):
        return V2(self.x / scalar, self.y / scalar)

    def __floordiv__(self, scalar: int):
        return V2(self.x // scalar, self.y // scalar)

    def __mod__(self, scalar: float):
        return V2(self.x % scalar, self.y % scalar)

    def __hash__(self):
        return hash((self.x, self.y))

    def floor(self) -> "V2i":
        return V2i(V2(int(self.x), int(self.y)))

    def length(self) -> float:
        return math.sqrt(self.x**2 + self.y**2)


# type for Iso vector space
IsoV = NewType("IsoV", V2)
V2i = NewType("V2i", V2)
VecType = Union["V2", "V2i"]


@dataclass
class SpriteSheet:
    texture: rl.Texture
    frames: int

    @property
    def width(self):
        return self.texture.width / self.frames

    def rect(self, frame_i: int) -> rl.Rectangle:
        return rl.Rectangle(self.width * frame_i, 0, self.width, self.texture.height)

    def draw_frame_iso(self, pos: V2, i: int, fliph: bool) -> DrawCall:
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

    def draw_frame_iso_tile(self, pos: V2i, i: int) -> DrawCall:
        r = self.rect(i)
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


@dataclass
class Sprites:
    sprites: Dict[str, SpriteSheet] = field(default_factory=dict)

    def load(self, filename, nframes=1):
        name = filename.split(".")[0]
        self.sprites[name] = SpriteSheet(rl.load_texture(filename), nframes)
        assert (
            self.sprites[name].texture.width % nframes == 0
        ), "not divisible by nframes"
        return name

    def __getattr__(self, name) -> SpriteSheet:
        return self.sprites[name]


SCREEN_WIDTH = 1200
SCREEN_HEIGHT = 700
BLOCK_WIDTH = 32
BLOCK_HEIGHT = BLOCK_WIDTH // 2
VIEW_SIZE = 16


class TileType(IntEnum):
    NONE = 0
    FLOOR = auto()
    START = auto()
    FIRE = auto()


class Map:
    start: V2i

    TILE_TYPE = {
        (255, 0, 255, 255): TileType.START,
        (255, 0, 0, 255): TileType.FIRE,
        (0, 0, 0, 255): TileType.FLOOR,
    }

    def __init__(self, img):
        map_img = rl.load_image(img)
        map_pixels = rl.load_image_colors(map_img)
        self.maparr = np.array(
            [
                Map.TILE_TYPE.get(
                    (
                        map_pixels[i].r,
                        map_pixels[i].g,
                        map_pixels[i].b,
                        map_pixels[i].a,
                    ),
                    TileType.NONE,
                )
                for i in range(map_img.width * map_img.height)
            ],
            dtype="int8",
        ).reshape((map_img.height, map_img.width))
        (y,), (x,) = np.where(self.maparr == TileType.START)
        self.start = V2(x, y).floor()
        self.maparr[y][x] = TileType.FLOOR
        rl.unload_image_colors(map_pixels)

    def tile(self, p: V2i):
        if 0 <= p.x < self.maparr.shape[1] and 0 <= p.y < self.maparr.shape[0]:
            return self.maparr[p.y][p.x]
        return TileType.NONE

    def find_path(self, start, goal) -> Optional[List[V2i]]:
        q: List[Tuple[float, V2i]] = [(0, start)]

        came_from: Dict[V2i, Optional[V2i]] = {}
        cost_so_far: Dict[V2i, float] = {}

        came_from[start] = None
        cost_so_far[start] = 0

        while q:
            _, current = heapq.heappop(q)
            if current == goal:
                break

            neighbors = [
                V2(current[0] - 1, current[1]).floor(),
                V2(current[0], current[1] - 1).floor(),
                V2(current[0] + 1, current[1]).floor(),
                V2(current[0], current[1] + 1).floor(),
            ]

            for n in neighbors:
                if self.tile(n) == TileType.FLOOR:
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


sprites = Sprites()


def xy_to_iso(pos) -> IsoV:
    return IsoV(
        V2((pos[0] - pos[1]) * BLOCK_HEIGHT, ((pos[0] + pos[1]) / 2) * BLOCK_HEIGHT)
    )


def iso_to_xy(v: IsoV) -> V2:
    v1 = V2(v.x / BLOCK_HEIGHT, v.y / BLOCK_HEIGHT)
    return V2((2 * v1.y + v1.x) / 2, (2 * v1.y - v1.x) / 2 + 1)


def iso_mouse_pos(state) -> IsoV:
    chunk_offset = (state.hero.pos // VIEW_SIZE) * VIEW_SIZE

    p = rl.get_screen_to_world_2d(rl.get_mouse_position(), camera)
    return iso_to_xy(p) + chunk_offset


def draw_grid_tile(tex: rl.Texture, pos: V2i, color=rl.WHITE) -> DrawCall:
    v = xy_to_iso(pos) + IsoV(V2(0, BLOCK_HEIGHT / 2 - tex.height))
    return (
        tex,
        rl.Rectangle(0, 0, tex.width, tex.height),
        rl.Rectangle(v[0], v[1], tex.width, tex.height),
        (0, 0),
        0,
        color,
    )


def highlight_tile(tile, chunk_offset):
    TIME = 0.4
    start = rl.get_time()
    while (diff := rl.get_time() - start) < TIME:
        p = xy_to_iso(tile - chunk_offset)
        poly = [
            p,
            p + V2(BLOCK_WIDTH / 2, -BLOCK_HEIGHT / 2),
            p + V2(BLOCK_WIDTH, 0),
            p + V2(BLOCK_WIDTH / 2, BLOCK_HEIGHT / 2),
            p,
        ]
        rl.draw_line_strip(
            [rl.Vector2(*x) for x in poly],
            len(poly),
            rl.fade(rl.YELLOW, 1 - (diff / TIME)),
        )
        yield


def walk_path(m: Map, hero, goal):
    path = m.find_path(hero.pos.floor(), goal)
    if not path:
        return

    t = 0
    last_pos = hero.pos
    while path:
        draw_calls.append(
            sprites.hero.draw_frame_iso(
                hero.pos, (t * 8) % 4, xy_to_iso(hero.pos).x - xy_to_iso(last_pos).x > 0
            )
        )
        yield

        t += rl.get_frame_time()

        last_pos = hero.pos
        diff = path[0] - hero.pos
        if diff.length() > 0.1:
            hero.pos += diff / (diff.length() * 10)
        else:
            hero.pos = path.pop(0)


sprites.load("hero.png", 4)
sprites.load("floor_fire.png", 5)
sprites.load("iso_floor.png", 1)

# MAIN

gamemap = Map("map1.png")

draw_calls: List[DrawCall] = []


@dataclass
class Hero:
    pos: V2
    goal: V2i


@dataclass
class State:
    hero: Hero


state = State(Hero(gamemap.start, gamemap.start))

# TODO: look at updating makeStructHelper to allow kwargs along with positional args.
camera = rl.Camera2D(
    (SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 - 160),  # offset
    (0, 0),  # target
    0,  # rotation
    2,  # zoom
)

hero_action = None
ui_coros = []


def step_game(state):
    global hero_action, ui_coros, gamemap
    chunk_offset = ((state.hero.pos // VIEW_SIZE) * VIEW_SIZE).floor()

    # logic
    if rl.is_key_pressed(rl.KEY_W):
        state.hero.pos += V2(0, 1)
    if rl.is_key_pressed(rl.KEY_S):
        state.hero.pos -= V2(0, 1)
    if rl.is_key_pressed(rl.KEY_A):
        state.hero.pos += V2(1, 0)
    if rl.is_key_pressed(rl.KEY_D):
        state.hero.pos -= V2(1, 0)

    if rl.is_mouse_button_released(rl.MOUSE_BUTTON_LEFT):
        p = iso_mouse_pos(state).floor()

        if chunk_offset.x - 1 <= p.x < chunk_offset.x + VIEW_SIZE + 1 and chunk_offset.y - 1 <= p.y < chunk_offset.y + VIEW_SIZE + 1:
            if gamemap.find_path(state.hero.pos.floor(), p) is not None:
                ui_coros.append(highlight_tile(p, chunk_offset))

                hero_action = walk_path(gamemap, state.hero, p)

    # draw map chunk
    def get_chunk(pos):
        x, y = pos
        assert chunk_offset[0] <= x < chunk_offset[0] + VIEW_SIZE
        assert chunk_offset[1] <= y < chunk_offset[1] + VIEW_SIZE
        return x % VIEW_SIZE, y % VIEW_SIZE

    for i in range(-1, VIEW_SIZE):
        ps = [V2(-1, i).floor(),
              V2(VIEW_SIZE, i + 1).floor(),
              V2(i + 1, -1).floor(),
              V2(i, VIEW_SIZE).floor(),
              ]

        for p in ps:
            if gamemap.tile(p + chunk_offset):
                draw_calls.append(draw_grid_tile(sprites.iso_floor.texture, p, rl.GRAY))


    for y in range(VIEW_SIZE):
        gy = int(y + chunk_offset[1])
        for x in range(VIEW_SIZE):
            gx = int(x + chunk_offset[0])
            p = V2(gx, gy).floor()
            if gamemap.tile(p) == TileType.FLOOR:
                draw_calls.append(draw_grid_tile(sprites.iso_floor.texture, (x, y)))
            if gamemap.tile(p) == TileType.FIRE:
                draw_calls.append(
                    sprites.floor_fire.draw_frame_iso_tile(
                        (x, y), int((rl.get_time() % 0.5) / 0.1)
                    )
                )

    if hero_action is None or next(hero_action, "complete") == "complete":
        draw_calls.append(sprites.hero.draw_frame_iso(state.hero.pos, 0, False))

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
