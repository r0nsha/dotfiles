`make install` runs `install/install.sh`. It is destructive: installs packages, clones assets, enables services, changes shell to fish, and runs `stow .`. Only run when explicitly requested.
VCS: use `jj`. Fall back to `git` if not a jj repo or jj binary missing.
Config allows for local overrides: `~/config.fish`, `~/.gitconfig.local`, `~/.config/jj/conf.d/local.toml`, `.config/nvim/lua/local.lua`.
Neovim: Use native `vim.pack` for plugins. Format with `stylua --check .config/nvim`. Installation managed by `bob` CLI.
Never run `hellwal` directly. Use `ron-theme-generate`, which handles light/dark mode, contrast checks, and applies the theme.
