import tarfile

from bin.download import download
from bin.env import Env
from bin.tools.utils import install_if_exists
from bin.utils import command


def install(env: Env):
    install_if_exists("starship", env, starship)
    # install_if_exists("rustup", env, rustup)


def starship(env: Env):
    dirname = env.dirs.downloads / "starship-x86_64-unknown-linux-musl.tar.gz"
    tarname = dirname.with_suffix(".tar.gz")
    binname = "starship"

    download(
        url="https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-musl.tar.gz",
        filename=tarname,
    )

    with tarfile.open(tarname, "r:gz") as tar:
        tar.extractall(path=dirname)

    _ = command(f"sudo cp {dirname / binname} {env.dirs.root_bin / binname}")


# def rustup(_env: Env):
#     _ = commands([runurl("https://starship.rs/install.sh")])
