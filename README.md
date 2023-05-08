# Dotfiles

## Install

```
git clone <this-repo>
cd <this-repo>
./bin/bootstrap.sh
```

## Local Fish Config

If there's customization you want Fish to load on startup that is specific to 
this machine (stuff you don't want to commit into the repo), after running `./bin/bootstrap.sh`, open `~/.env.fish`
and put it all in there. It will be loaded at the top of `fish/config.fish`.

## Font

The config assumes that you have [Iosevka Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.0/Iosevka.zip) installed on this machine.

## References

- [andrew8088/dotfiles](https://github.com/andrew8088/dotfiles)
- [theprimeagen/.dotfiles](https://github.com/theprimeagen/.dotfiles)
- [gilbarbara/dotfiles](https://github.com/gilbarbara/dotfiles)
