from bin.env import Env, Os
from bin.tools import linux, macos, shared


def install_tools(env: Env):
    shared.install(env)

    match env.os:
        case Os.Linux:
            linux.install(env)
        case Os.MacOS:
            macos.install(env)
