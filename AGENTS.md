# Repo Notes

- This is a Dotfiles repo. You can check for configuration files here instead of reading `XDG_CONFIG_HOME` or `~/.config`.
- Dotfiles install target is `make install`; it only runs `./install/install.sh`.
- This repo uses Jujutsu (`jj`) for VCS workflow; use `jj` commands instead of `git` unless explicitly asked.
- Treat `make install` as destructive/bootstrap work: it installs packages, clones assets, enables services, changes shells, and runs `stow .`. Run only when explicitly requested.
- `stow .` targets `~/.config` via `.stowrc`; use `stow -n .` for dry-run symlink checks.
- New top-level repo-only files need `.stow-local-ignore` entries or Stow will link them into `~/.config`.

# Layout

- Most directories are Stow packages mapping directly under `~/.config`.
- Every file under `bin/` must be prefixed with `ron-`.
- `.stow-local-ignore` excludes special cases: `install`, `gpg`, `ly`, `ssh`, `.pam-gnupg`, `.jj`, and `jj/conf.d` are handled manually or locally.
- `install/install.sh` creates `~/.env.fish` with `DOTFILES`; `fish/config.fish` requires it before loading repo Fish files.
- Machine-local Fish overrides belong in `~/config.fish`, not this repo.
- Local Git/JJ overrides belong in `~/.gitconfig.local` and `~/.config/jj/conf.d/local.toml`.

# Platform Install Flow

- Linux platform detection only supports `/etc/os-release` IDs `arch`, `ubuntu`, and `pop`.
- Arch flow uses `pacman`, `paru`, `pipx`, `rustup`, enables user services from `systemd/user`, and enables Docker/Bluetooth/ly.
- macOS flow uses Homebrew and links `qutebrowser` to `~/.qutebrowser` outside Stow.
- Ubuntu flow runs several source/build installers with `curl`/`wget`; inspect before executing.

# Neovim

- Neovim entrypoint is `nvim/init.lua`; plugins use native `vim.pack.add`, not lazy.nvim.
- Plugin lockfile is `nvim/nvim-pack-lock.json`; update plugins from Neovim with `:PackUpdate [name]`.
- Lua formatting follows root `stylua.toml` with 2 spaces, width 120, double-quote preference; check with `stylua --check nvim`.

# Walker/Elephant

- After updating Walker or Elephant config/menus/providers, run `systemctl --user restart --now elephant.service walker.service` so both services reload the stowed changes.

# hellwal

- NEVER run `hellwal` directly unless explicitly prompted. ALWAYS run `hellwal` via `./bin/ron-theme-generate` so theme context (light/dark mode, contrast check, hooks) is applied correctly.

# Existing Agent Config

- `opencode/AGENTS.md` is user communication style and is stowed to `~/.config/opencode/AGENTS.md`; keep repo workflow notes in this root file.

# Bash Tool / Root Access

- Bash tool commands requiring `sudo` or root access must be run manually by the user. The tool cannot handle interactive password prompts.
