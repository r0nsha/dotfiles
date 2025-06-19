import os

from bin import steps
from bin.env import Env


def main():
    env = Env()
    os.chdir(env.dirs.dotfiles)
    steps.all(env)
    print("your things are installed, bye!")


if __name__ == "__main__":
    main()
