import os

from bin import log
from bin.types import Env


def main():
    env = Env()
    os.chdir(env.dirs.dotfiles)

    with open(env.dirs.dotfiles / "bin/pepe.txt", "r") as f:
        print(f.read())

    os.makedirs(env.dirs.downloads, exist_ok=True)
    os.makedirs(env.dirs.local_bin, exist_ok=True)
    os.makedirs(env.dirs.local_share, exist_ok=True)

    log.running("doing git things...")


if __name__ == "__main__":
    main()
