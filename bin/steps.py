import os
import shutil

from bin.run import Run, command, commands
from bin.types import Env, Os


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
        _ = command(
            f"ln -sf {env.dirs.dotfiles}/wallpapers {env.dirs.home}/Pictures/Wallpapers"
        )


def dconf(env: Env):
    with Run("load dconf"):
        if shutil.which("dconf"):
            _ = command(f"dconf load / <{env.dirs.dotfiles}/dconf/settings.ini")


def gtk_theme(env: Env):
    if env.os != Os.Linux:
        return

    with Run("setup gtk theme"):
        gtk_themes = env.dirs.local_share / "themes"
        gtk_icons = env.dirs.local_share / "icons"

        os.makedirs(gtk_themes, exist_ok=True)
        os.makedirs(gtk_icons, exist_ok=True)

        commands(
            [
                f'sudo bash -c "{env.dirs.dotfiles}/gtk/Rose-Pine-GTK-Theme/themes/install.sh --dest {gtk_themes} --name Rose-Pine --theme default --size compact --tweaks black"',
                f"cp -r {env.dirs.dotfiles}/gtk/Rose-Pine-GTK-Theme/icons {gtk_icons}",
            ]
        )


def stow(env: Env):
    with Run("stow dotfiles"):
        os.chdir(env.dirs.dotfiles)
        _ = command("stow .")


def shell():
    with Run("setup default shell"):
        fish_bin = shutil.which("fish")

        if fish_bin is None:
            raise ValueError(
                "fish is not installed, this is a bug in the install script"
            )

        _ = command("sudo tee -a /etc/shells", input=f"{fish_bin}\n")
        _ = command(f"sudo chsh -s {fish_bin}")
