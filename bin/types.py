import platform
from enum import Enum
from pathlib import Path


class Os(Enum):
    LINUX = "linux"
    MACOS = "macos"

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
    downloads: Path
    local_bin: Path
    local_share: Path

    def __init__(self):
        bindir = Path(__file__).parent
        self.dotfiles = (bindir / "..").resolve()
        home = Path.home()
        self.downloads = home / "Downloads"
        self.local_bin = home / ".local/bin"
        self.local_share = home / ".local/share"


class Env:
    dirs: Dirs
    os: Os

    def __init__(self):
        self.dirs = Dirs()
        self.os = Os.from_system()
