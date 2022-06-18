![image](https://user-images.githubusercontent.com/1291012/174444171-cde55ba9-5a64-4e8a-81f0-f66d2080e2db.png)

Unsubmitted game for adventure jam 2022 (ran out of time during development).

Originally started as a zig game, but switched to python to improve iteration
speed.

    $ pip3 install raylib numpy
    $ python3 wrapper.py

    # hit F5 to hot reload python source in game.py

## Notes

* Switched to Python so I could easily implement hot-reload and have a reliable coroutine implementation (I kept running into problems with Zig's `async`)
* 3/4 isometric took more time to implement than I anticipated.
* Hacking away with hot-reload would have streamlined early iteration. I should have started out with it.
* `nuitka` can be used to distribute python + raylib projects. It allegedly mixes well with native code, so maybe I still utilize Zig for parts of the game.
* The Python implementation (both interpreted and compiled through `nuitka`) uses roughly ~10x CPU time and ~1.5x memory compared to the Zig version. (When eyeballing `top` while running the game.)
    * I was surprised that `nuitka` didn't impact the CPU usage much. It implies that the Python interpreter loop isn't a bottleneck. The code is simple, but that means I can wring a lot more out of Python for this type of project.
