import os
import platform
from enum import Enum
from pathlib import Path


class Os(Enum):
    Linux = "linux"
    Darwin = "darwin"

    @staticmethod
    def from_string(os_str: str):
        for os_enum in Os:
            if os_enum.value.lower() == os_str.lower():
                return os_enum
        raise ValueError(f"'{os_str}' is not a valid OS")

    @staticmethod
    def from_system():
        return Os.from_string(platform.system())


class Dirs:
    dotfiles: Path
    home: Path
    downloads: Path
    local_bin: Path
    local_share: Path
    root_bin: Path

    def __init__(self):
        bindir = Path(__file__).parent
        self.dotfiles = (bindir / "..").resolve()
        self.home = Path.home()
        self.downloads = self.home / "Downloads"
        self.local_bin = self.home / ".local/bin"
        self.local_share = self.home / ".local/share"
        self.root_bin = Path("/usr/local/bin")

        os.environ["DOTFILES"] = str(self.dotfiles)
        os.environ["DOWNLOADS"] = str(self.downloads)


class Env:
    dirs: Dirs
    os: Os

    def __init__(self):
        self.dirs = Dirs()
        self.os = Os.from_system()
