import os
from pathlib import Path

from bin.types import Env, Os


def main():
    bindir = Path(__file__).parent
    dotfilesdir = (bindir / "..").resolve()
    os.chdir(dotfilesdir)

    env = Env(dotfiles=dotfilesdir, os=Os.from_system())

    pass


if __name__ == "__main__":
    main()
