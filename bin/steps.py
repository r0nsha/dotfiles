import concurrent.futures
import os
import shutil
import sys
import zipfile
from dataclasses import dataclass
from pathlib import Path
from typing import Callable

from bin import log
from bin.download import download_all
from bin.env import Env, Os
from bin.tools import install_tools
from bin.utils import clear_screen, command, commands


class Status:
    pass


class Pending(Status):
    pass


class Running(Status):
    pass


class Done(Status):
    pass


@dataclass
class Error(Status):
    msg: str


@dataclass
class Step:
    name: str
    fn: Callable[[Env], None]
    status: Status = Pending()

    def print(self):
        match self.status:
            case Pending():
                log.pending(self.name)
            case Running():
                log.running(self.name)
            case Done():
                log.success(self.name)
            case Error(msg):
                log.error(f"{self.name}: {msg}")
            case _:
                log.error(f"invalid status: {repr(self.status)}")
                sys.exit(1)


class Steps:
    env: Env
    steps: list[Step]
    pepe: str

    def __init__(self, env: Env, steps: list[Step]):
        self.env = env
        self.steps = steps
        with open(env.dirs.dotfiles / "bin/pepe.txt", "r") as f:
            self.pepe = f.read()

    def _print_steps(self):
        clear_screen()
        print(self.pepe)
        for step in self.steps:
            step.print()
        print()

    def run_all(self):
        for step in self.steps:
            try:
                step.status = Running()
                self._print_steps()
                step.fn(self.env)
                step.status = Done()
            except Exception as e:
                step.status = Error(str(e))
            self._print_steps()


def all(env: Env):
    Steps(
        env,
        steps=[
            Step("create env", do_env),
            Step("create use dirs", do_mkdirs),
            Step("setup git", do_git),
            Step("setup wallpapers", do_wallpapers),
            Step("load dconf", do_dconf),
            Step("setup gtk theme", do_gtk_theme),
            Step("install fonts", do_fonts),
            Step("install tools", do_tools),
            Step("stow dotfiles", do_stow),
            Step("setup default shell", do_shell),
        ],
    ).run_all()


def do_env(env: Env):
    path = os.path.expanduser("~/.env.fish")
    try:
        with open(path, "w") as f:
            _ = f.write(f"set -Ux DOTFILES {env.dirs.dotfiles}")
            print(f"File '{path}' created and content written.")
    except FileExistsError:
        pass  # ignore if already exists


def do_mkdirs(env: Env):
    env.dirs.downloads.mkdir(parents=True, exist_ok=True)
    env.dirs.local_bin.mkdir(parents=True, exist_ok=True)
    env.dirs.local_share.mkdir(parents=True, exist_ok=True)
    env.dirs.root_bin.mkdir(parents=True, exist_ok=True)


def do_git(env: Env):
    commands(
        [
            f"chmod ug+x {env.dirs.dotfiles}/hooks/*",
            "git submodule init",
            "git submodule update --init --recursive",
        ]
    )


def do_wallpapers(env: Env):
    _ = command(
        f"ln -sf {env.dirs.dotfiles}/wallpapers {env.dirs.home}/Pictures/Wallpapers"
    )


def do_dconf(env: Env):
    if shutil.which("dconf"):
        _ = command(f"dconf load / <{env.dirs.dotfiles}/dconf/settings.ini")


def do_gtk_theme(env: Env):
    if env.os != Os.Linux:
        return

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


def do_fonts(env: Env):
    fonts_dir: Path
    match env.os:
        case Os.Linux:
            fonts_dir = env.dirs.local_share / "fonts"
        case Os.MacOS:
            fonts_dir = Path("/Library/Fonts")

    os.makedirs(fonts_dir, exist_ok=True)

    fonts_base_url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0"

    def not_installed_fonts(fonts: list[str]) -> list[str]:
        font_files = os.listdir(fonts_dir)
        not_installed: list[str] = []
        for font in fonts:
            pattern = font.replace(" ", "") + "NerdFont"
            if not any(pattern in f for f in font_files):
                not_installed.append(font)
        return not_installed

    fonts = not_installed_fonts(["Iosevka", "IosevkaTerm"])

    to_download = [
        (f"{fonts_base_url}/{font}.zip", env.dirs.downloads / f"{font}.zip")
        for font in fonts
    ]
    download_all(to_download)

    def unzip_font(src: Path, dest: Path):
        with zipfile.ZipFile(src, "r") as zipref:
            ttf_members = [
                member for member in zipref.namelist() if member.endswith(".ttf")
            ]
            if ttf_members:
                print(f"unzipping {src} to {dest}")
                zipref.extractall(dest, members=ttf_members)

    with concurrent.futures.ThreadPoolExecutor() as executor:
        futures = [
            executor.submit(unzip_font, file_item, fonts_dir)
            for _, file_item in to_download
        ]

        for future in concurrent.futures.as_completed(futures):
            future.result()


def do_tools(env: Env):
    install_tools(env)


def do_stow(env: Env):
    os.chdir(env.dirs.dotfiles)
    _ = command("stow .")


def do_shell(_env: Env):
    fish_bin = shutil.which("fish")

    if fish_bin is None:
        raise ValueError("fish is not installed, this is a bug in the install script")

    _ = command("sudo tee -a /etc/shells", input=f"{fish_bin}\n")
    _ = command(f"sudo chsh -s {fish_bin}")
