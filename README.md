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

After installing it, run `scripts/patch_berkeley_mono.fish`

## Local Fish Config

```
~/config.fish
```

If there's customization you want Fish to load on startup that is specific to
this machine. It will be loaded at the top of `fish/config.fish`.

## Local Git & JJ Configs

```
~/.gitconfig.local
~/.config/jj/conf.d/local.toml

```

Useful for customization such as modifying the `[user]` section.

## MacOS Defaults

If you're on MacOS and want some sensible defaults, you can run `./bin/macos_defaults.sh`.

## References

- [andrew8088/dotfiles](https://github.com/andrew8088/dotfiles)
- [theprimeagen/.dotfiles](https://github.com/theprimeagen/.dotfiles)
- [gilbarbara/dotfiles](https://github.com/gilbarbara/dotfiles)
