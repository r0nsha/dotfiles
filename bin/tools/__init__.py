from bin.env import Env, Os
from bin.utils import command


# TODO: convert to python after i move to arch
def install_tools(env: Env):
    match env.os:
        case Os.Linux:
            _ = command(
                f"bash {env.dirs.dotfiles}/bin/tools/linux.sh", capture_output=False
            )
            # linux.install(env)
        case Os.MacOS:
            _ = command(
                f"bash {env.dirs.dotfiles}/bin/tools/macos.sh", capture_output=False
            )
            # macos.install(env)
