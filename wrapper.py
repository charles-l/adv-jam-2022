import pyray as rl
from importlib import reload
import traceback as tb

SCREEN_WIDTH = 1200
SCREEN_HEIGHT = 700
rl.init_window(SCREEN_WIDTH, SCREEN_HEIGHT, "game")
rl.set_target_fps(60)

import game  # noqa
state = game.state
error = None

while not rl.window_should_close():
    rl.begin_drawing()
    rl.clear_background(rl.GRAY)

    if rl.is_key_released(rl.KEY_F5):
        error = None
        reload(game)

    if error is None:
        try:
            game.step_game(state)
        except Exception as e:
            error = e
    else:
        rl.draw_text(''.join(tb.format_exception(None, error, error.__traceback__)), 10, 40, 20, rl.RED)

    rl.draw_fps(10, 10)
    rl.end_drawing()

rl.close_window()
