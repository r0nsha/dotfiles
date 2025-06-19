import os
import platform
import pwd
from enum import Enum
from pathlib import Path


def get_original_user_home():
    """
    Returns the home directory of the user who invoked the script,
    even if the script is running with sudo.
    """
    # Check if the script is running with sudo
    if os.geteuid() == 0:  # os.geteuid() returns the effective user ID
        # If running as root, check for SUDO_USER environment variable
        sudo_user = os.getenv("SUDO_USER")
        if sudo_user:
            try:
                # Get user information from the password database
                user_info = pwd.getpwnam(sudo_user)
                return Path(user_info.pw_dir)
            except KeyError:
                # SUDO_USER exists but user info not found (unlikely for valid users)
                print(
                    f"Warning: SUDO_USER '{sudo_user}' not found in password database."
                )
                return (
                    Path.home()
                )  # Fallback to root's home if original user cannot be determined
        else:
            # SUDO_USER not set, but running as root (e.g., direct login as root)
            return Path.home()  # Returns /root
    else:
        # Not running with sudo, so Path.home() will be correct
        return Path.home()


class Os(Enum):
    Linux = "linux"
    MacOS = "macos"

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

    def __init__(self):
        bindir = Path(__file__).parent
        self.dotfiles = (bindir / "..").resolve()
        self.home = get_original_user_home()
        self.downloads = self.home / "Downloads"
        self.local_bin = self.home / ".local/bin"
        self.local_share = self.home / ".local/share"


class Env:
    dirs: Dirs
    os: Os

    def __init__(self):
        self.dirs = Dirs()
        self.os = Os.from_system()
