# Repo Notes

- Dotfiles repo. Check config here instead of reading `XDG_CONFIG_HOME` or `~/.config`.
- Install target is `make install`; only runs `./install/install.sh`.
- VCS is Jujutsu (`jj`); use `jj` unless explicitly asked for `git`.
- Treat `make install` as destructive bootstrap: installs packages, clones backgrounds + tpm, enables system/user services, `chsh` to fish, runs `stow .`. Run only when explicitly requested.
- `stow .` targets `~` via `.stowrc` (`--target=~`); dry-run with `stow -n .`.
- New top-level repo-only files need `.stow-local-ignore` entries or Stow will link them into `~` (see `^/AGENTS.md`, `^/README.*`).

# Layout

- Stow packages map to `~`: XDG configs live under `.config/` (→ `~/.config/<dir>`), scripts under `.local/bin/` (→ `~/.local/bin`), GPG under `.gnupg/` (→ `~/.gnupg`), SSH under `.ssh/` (→ `~/.ssh`), root dotfiles like `.curlrc` link directly to `~/.curlrc`.
- Every file under `.local/bin/` is prefixed `ron-`; most are `#!/usr/bin/env fish`. They run from the stowed `~/.local/bin` (on fish PATH).
- `.stow-local-ignore` + `.gitignore` share entries for machine-local / generated paths: `install`, `\.jj`, `^/ly`, `^/.config/jj/conf.d`, `.config/jj/repos`, `.config/nvim/lua/local.lua`, `.config/qutebrowser/autoconfig.yml`, `.config/qutebrowser/qsettings`, `.config/tmux/plugins`, `.config/fish/completions`, `.config/fish/conf.d`, `.config/fish/fish_variables*`, `.config/kitty/current_theme.conf`, `.config/waybar/style.css`, `.venv`, `__pycache__`.
- `install/install.sh` creates `~/.env.fish` with `set -Ux DOTFILES <path>`; `.config/fish/config.fish` sources it first and won't load repo files without it.
- Machine-local Fish overrides: `~/config.fish`. Local Git/JJ overrides: `~/.gitconfig.local` and `~/.config/jj/conf.d/local.toml`. Neovim local overrides: `.config/nvim/lua/local.lua`.
- `install.sh` sets `~/.gnupg` perms after stow. `ly/config.ini` is sudo-linked to `/etc/ly/config.ini` (not Stow — system path).

# Platform Install Flow

- Linux detection (`install/platform.sh`) supports only `/etc/os-release` `ID=arch`; any other `ID` errors out with "add support to dotfiles". Darwin runs `macos.sh`.
- Arch flow: `paru -Syu` deps, `pipx install`, `rustup` stable+nightly, enables system services (chrony, cronie, iwd) and user services from `.config/systemd/user`, enables Docker/Bluetooth/ly, adds user to gamemode/network/input/i2c groups.
- macOS flow: Homebrew deps, writes `pinentry-mac` to `gpg-agent.conf`.

# Neovim

- Entrypoint `.config/nvim/init.lua`; plugins use native `vim.pack.add`, not lazy.nvim.
- Plugin sources via `.config/nvim/lua/utils/pack.lua` helpers: `src.gh` (github), `src.tngl` (tangled.org), `src.cb` (codeberg). Colorscheme `nor.nvim` from `tngl("ronshavit.com/nor.nvim")`.
- Lockfile `.config/nvim/nvim-pack-lock.json`; update from Neovim with `:PackUpdate [name]`.
- `bob` manages the nvim binary; `~/.local/share/bob/nvim-bin` is on fish PATH.
- Lua formatting: root `stylua.toml` — 2 spaces, `column_width = 100`, `AutoPreferDouble`. Check with `stylua --check .config/nvim`.

# hellwal

- NEVER run `hellwal` directly unless explicitly prompted. ALWAYS run `ron-theme-generate` so theme context (light/dark mode via `ron-theme-get`, `--check-contrast`, `--bright-offset` for light, `ron-theme-apply` hook) is applied.
- Templates live in `.config/hellwal/templates/`; `ron-theme-apply` writes generated outputs (`.config/kitty/current_theme.conf`, `.config/waybar/style.css`, etc.) which are gitignored + stow-ignored.

# JJ Workflow

- Main config is `.config/jj/config.toml` (user, ui, merge-tools.diffconflicts, fsmonitor.watchman, aliases). Machine-local overrides in `~/.config/jj/conf.d/local.toml`.
- Push convention: `push-new-bookmarks = false`, `[remotes.origin] auto-track-bookmarks = 'ron/*'`, `git_push_bookmark = "ron/" ++ change_id.short()`. Use `jj pmine` (`git push -b glob:ron/*`) to push your branches.
- Private commits: `description(glob:'wip:*') | description(glob:'private:*')` are blocked from push.
- Useful aliases: `ret`/`retrunk` (rebase to trunk skipping emptied), `retall`, `pullup`, `mine` (my bookmarks), `branches` (all heads), `l` (focused log), `la`, `gc` (abandon empty), `si` (squash interactive).

# OpenCode Config

- `.config/opencode/AGENTS.md` is user communication style, stowed to `~/.config/opencode/AGENTS.md`. Keep repo workflow notes in this root file.
- `.config/opencode/opencode.json` permission rules mark many ops `ask` (require user confirmation): `jj ci*`, `jj commit*`, `jj new*`, `jj b*`, `jj restore*`, `jj abandon*`, `git commit/push/checkout/reset`, `stow*`, `paru*`, `brew install/upgrade/uninstall`, `cargo install`, `pipx install`, `npm install -g`, `curl|bash`, `wget|bash`, `chsh`, `kill*`, `pkill*`, `reboot/poweroff/hibernate`, `rm*`. Plan for confirmation prompts on these.
- `snapshot: false`; MCP `context7` remote enabled.
- Caveman skills live in `.config/opencode/skills/` (`caveman`, `caveman-commit`, `caveman-compress`, `caveman-help`, `caveman-review`); `.config/opencode/themes/nor.json` is the TUI theme.

# Bash Tool / Root Access

- Bash tool commands requiring `sudo` or root access must be run manually by the user; the tool cannot handle interactive password prompts.
