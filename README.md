# Dotfiles

## Install

```
git clone <this-repo>
cd <this-repo>
make install
```

## Manual Installs

This config uses [Berkeley Mono](https://usgraphics.com/products/berkeley-mono) as the system font, so it needs to be installed manually.

Prerequisites:

- Docker CLI
- Installed and unzipped the font from their [website](https://usgraphics.com/products/berkeley-mono)

After installing it, run the following:

```sh
cp 251015*/TX-02-* /tmp/original
cd /tmp
mkdir patched
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts

newgrp docker

# Mono
docker run --rm \
        -v /tmp/original:/in \
        -v /tmp/patched:/out \
        nerdfonts/patcher \
        --complete

# Propo
docker run --rm \
        -v /tmp/original:/in \
        -v /tmp/patched:/out \
        nerdfonts/patcher \
        --complete \
        --variable-width-glyphs

mkdir ~/.local/share/fonts
cp /tmp/patched/* ~/.local/share/fonts
```

## Local Fish Config

If there's customization you want Fish to load on startup that is specific to
this machine (stuff you don't want to commit into the repo), after running `./bin/install.sh`, open `~/.env.fish`
and put it all in there. It will be loaded at the top of `fish/config.fish`.

## MacOS Defaults

If you're on MacOS and want some sensible defaults, you can run `./bin/macos_defaults.sh`.

## References

- [andrew8088/dotfiles](https://github.com/andrew8088/dotfiles)
- [theprimeagen/.dotfiles](https://github.com/theprimeagen/.dotfiles)
- [gilbarbara/dotfiles](https://github.com/gilbarbara/dotfiles)
