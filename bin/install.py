import os

from bin import steps
from bin.types import Env


def main():
    env = Env()
    os.chdir(env.dirs.dotfiles)

    with open(env.dirs.dotfiles / "bin/pepe.txt", "r") as f:
        print(f.read())

    steps.env(env)
    steps.mkdirs(env)
    steps.git(env)
    steps.wallpapers(env)


if __name__ == "__main__":
    main()
