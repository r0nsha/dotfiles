import platform
from dataclasses import dataclass
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


@dataclass
class Env:
    dotfiles: Path
    os: Os
