from typing import Callable

from bin.env import Env


def install_if_exists(name: str, env: Env, fn: Callable[[Env], None]):
    # if shutil.which(name):
    #     print(f"`{name}` is already installed, skipping")
    # else:
    fn(env)
