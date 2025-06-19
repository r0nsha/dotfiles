import os
import shutil

from bin.run import Run, command, commands
from bin.types import Env


def mkdirs(env: Env):
    os.makedirs(env.dirs.downloads, exist_ok=True)
    os.makedirs(env.dirs.local_bin, exist_ok=True)
    os.makedirs(env.dirs.local_share, exist_ok=True)


def env(env: Env):
    path = os.path.expanduser("~/.env.fish")
    with Run(f"create {path}"):
        try:
            with open(path, "x") as f:
                _ = f.write(f"set -Ux DOTFILES {env.dirs.dotfiles}")
                print(f"File '{path}' created and content written.")
        except FileExistsError:
            pass  # ignore if already exists


def git(env: Env):
    with Run("setup git"):
        commands(
            [
                f"chmod ug+x {env.dirs.dotfiles}/hooks/*",
                "git submodule init",
                "git submodule update --init --recursive",
            ]
        )


def wallpapers(env: Env):
    with Run("setup wallpapers"):
        command(f"ln -sf {env.dirs.dotfiles}/wallpapers ~/Pictures/Wallpapers")


def dconf(env: Env):
    with Run("load dconf"):
        if shutil.which("dconf"):
            command(f"dconf load / <{env.dirs.dotfiles}/dconf/settings.ini")


def stow(env: Env):
    with Run("stow dotfiles"):
        os.chdir(env.dirs.dotfiles)
        command("stow .")


def shell():
    with Run("setup default shell"):
        fish_bin = shutil.which("fish")

        if fish_bin is None:
            raise ValueError(
                "fish is not installed, this is a bug in the install script"
            )

        command("sudo tee -a /etc/shells", input=f"{fish_bin}\n")
        command(f"sudo chsh -s {fish_bin}")
