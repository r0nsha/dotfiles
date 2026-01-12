# Agent Guidelines for Dotfiles Repository

## Build/Lint/Test Commands

This is a dotfiles repository with no traditional build process. Use these commands for validation:

### Installation
- **Full install**: `make install` (runs `./bin/install.sh`)
- **Install script**: `./bin/install.sh` (idempotent bootstrap)

### Linting & Formatting
- **Lint Lua**: `stylua --check nvim/`
- **Format Lua**: `stylua nvim/`
- **Lint Fish script**: `fish --no-execute path/to/script.fish`
- **Lint Shell**: `shellcheck bin/*.sh` (if available)

### Testing
No test framework configured. Manual testing only:
- Run `make install` for integration testing
- Test individual scripts directly: `./bin/install.sh`, `./scripts/set_theme.fish`, etc.

## Version Control

This repository uses **Jujutsu (jj)** as the primary version control system:

- **Status**: `jj status`
- **Diff**: `jj diff`
- **Log**: `jj log`
- **Commit**: `jj commit -m "message"`
- **Add files**: `jj add <files>`
- **Push**: `jj git push`

**Important**: Git commands in bootstrap scripts (`bin/install.sh`, `bin/tools.sh`) are intentional:
- Git submodules must be managed via git (not jj)
- External repo clones (tpm, backgrounds) use git clone
- Do not convert these to jj commands

## Repository Structure

- `bin/`: Bootstrap and utility scripts (install.sh, utils.sh, tools.sh)
- `nvim/`: Neovim configuration (Lua-based, uses native vim.pack.add)
- `fish/`: Fish shell configuration (config, functions, aliases, variables)
- `scripts/`: Utility scripts (mostly Fish, some Bash)
- `rofi/scripts/`: Rofi launcher scripts
- `i3blocks/scripts/`, `waybar/scripts/`: Status bar scripts
- Root level: App configs (alacritty/, kitty/, tmux/, hypr/, etc.)

## Code Style Guidelines

### Lua (Neovim Config)

**Formatting** (stylua.toml):
- 120 column width
- 2-space indentation
- Double quotes preferred (auto)
- Call parentheses always required
- Auto-collapse simple statements

**File Organization**:
- `nvim/init.lua`: Entry point, package declarations
- `nvim/lua/config/`: Core config (opts, remap, autocmd)
- `nvim/lua/plugins/`: Plugin configurations
- Modular structure: separate concerns into individual files

**Imports**:
- Use `require()` statements at file top
- Auto-sorted by stylua
- Group related requires together

**Naming**:
- `snake_case` for variables and functions
- `PascalCase` for modules
- Descriptive names, avoid abbreviations

**Error Handling**:
- Use `pcall()` for optional requires
- Explicit error messages when operations can fail
- Example: `local ok, module = pcall(require, "module")`

**Package Management**:
- Uses native `vim.pack.add()` (NOT lazy.nvim)
- Declare packages in `init.lua`
- Configure in separate plugin files under `lua/plugins/`

### Shell Scripts (Bash)

**Shebang**: Always use `#!/usr/bin/env bash`

**Safety**: Always include at top (after shebang):
```bash
set -euo pipefail
```

**Quoting**: ALWAYS quote variable expansions to handle spaces:
- Correct: `cd "$DOTFILES"`, `source "$DOTFILES/bin/utils.sh"`
- Wrong: `cd $DOTFILES`, `source $DOTFILES/bin/utils.sh`
- Quote paths in commands: `mkdir -p "$LOCAL_BIN" "$LOCAL_OPT"`
- Exception: Wildcards after quoted prefix: `chmod +x "$DOTFILES"/scripts/*`

**Bootstrap Script Patterns** (from bin/utils.sh):
Use the step/success/error/info functions for consistent output:
```bash
step "descriptive step name"
# ... do work ...
success

info "informational message"

error "error message"  # exits with status 1
```

**Error Handling**:
- Use trap for cleanup: `trap '[ -n "$CURR_STEP" ] && error' EXIT`
- Check command success: `if ! stow .; then error "stow failed"; fi`
- Provide clear, actionable error messages
- Exit with non-zero status on failure

**Idempotency**: Scripts should be re-runnable safely:
- Check before installing: `if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then`
- Use `install_wrapper` function from utils.sh
- Skip work if already done: `info "skipped (already installed)"`

**Functions**:
- Use local variables: `local var_name="value"`
- Descriptive names, no unnecessary abbreviations
- Reuse utilities from `bin/utils.sh`

**Variable Naming**:
- UPPERCASE for global/env variables: `DOTFILES`, `LOCAL_BIN`
- lowercase for local variables: `script_dir`, `fish_bin`

### Shell Scripts (Fish)

**Shebang**: Always use `#!/usr/bin/env fish`

**Variables**:
- Local variables: `set -l variable_name value`
- Universal exports: `set -Ux XDG_CONFIG_HOME ~/.config`
- Local exports: `set -x VARIABLE value` (current session)

**Conditionals**:
- Use `test` for checks: `if test -d $path`
- Command existence: `command -v -q program` or use `binary_exists` function
- File existence: `test -r $file`, `test -f $file`, `test -d $dir`

**Functions**:
- Keep simple and focused
- Avoid complex logic, prefer clarity over cleverness
- Use descriptive names: `tmux_select_dir`, `filter_dirs`
- Example pattern:
```fish
function my_function
    set -l local_var value
    if test (count $argv) -eq 0
        echo "Usage: my_function <args>"
        return 1
    end
    # ... work ...
end
```

**Error Handling**:
- Check command success: `if not command; echo "failed"; return 1; end`
- Provide clear error messages
- Return non-zero on failure

### General Conventions

**Comments**:
- Brief comments only for complex operations
- Do NOT add obvious comments explaining what code does
- Explain WHY, not WHAT

**Whitespace**:
- No trailing whitespace (formatters handle automatically)
- Consistent indentation per language

**Quoting in Shell Scripts**:
- Always quote variable expansions in Bash/Fish
- Use double quotes for interpolation
- Use single quotes for literals (when no interpolation needed)

**Modular Configuration**:
- Separate concerns into different files
- Use clear file names indicating purpose
- Keep files focused and reasonably sized

**Documentation**:
- Update README.md for significant user-facing changes
- Document manual steps (e.g., Berkeley Mono font installation)
- Keep AGENTS.md updated with new patterns

**Idempotency in Bootstrap Scripts**:
- All install scripts must be safely re-runnable
- Check existence before creating/cloning/installing
- Use conditional logic to skip already-completed work
- Provide feedback when skipping: `info "already installed"`

**Local Configuration Files**:
Users can customize via local config files (not tracked):
- `~/.env.fish`: Loaded first by fish config
- `~/config.fish`: Loaded after main fish config
- `~/.gitconfig.local`: Git user config
- `~/.config/jj/conf.d/local.toml`: Jujutsu user config

## Supported Languages & Tools

**Primary Languages**: Lua, Fish, Bash

**LSP Support Configured For**:
- Python (ruff)
- JavaScript/TypeScript (biome, prettier)
- Rust (rust-analyzer)
- Go (gopls)
- C/C++ (clangd)
- And many others via Mason

**Key Tools**:
- Editor: Neovim (native packages via vim.pack.add)
- Shell: Fish with Tide prompt
- Terminal: Kitty, Alacritty
- Multiplexer: Tmux
- Version Control: Jujutsu (jj)
- File Manager: Yazi
- Fuzzy Finder: fzf, skim
