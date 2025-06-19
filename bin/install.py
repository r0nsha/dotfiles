import os

from bin import steps
from bin.env import Env


def main():
    env = Env()
    os.chdir(env.dirs.dotfiles)

    with open(env.dirs.dotfiles / "bin/pepe.txt", "r") as f:
        print(f.read())

    steps.all(env)

    print("\nyour things are installed, bye!")


if __name__ == "__main__":
    main()
