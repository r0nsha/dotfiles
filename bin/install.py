import os

from bin.run import Run, commands
from bin.types import Env


def main():
    env = Env()
    os.chdir(env.dirs.dotfiles)

    with open(env.dirs.dotfiles / "bin/pepe.txt", "r") as f:
        print(f.read())

    os.makedirs(env.dirs.downloads, exist_ok=True)
    os.makedirs(env.dirs.local_bin, exist_ok=True)
    os.makedirs(env.dirs.local_share, exist_ok=True)

    with Run("git submodules"):
        commands(
            [
                f"chmod ug+x {env.dirs.dotfiles}/hooks/*",
                "git submodule init",
                "git submodule update --init --recursive",
            ]
        )


if __name__ == "__main__":
    main()
