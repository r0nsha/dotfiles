# AGENTS.md

This file contains guidelines for AI agents working in this dotfiles repository.

## Repository Overview

This is a personal dotfiles repository managed with [GNU Stow](https://www.gnu.org/software/stow/). Configurations are symlinked to `~/.config` using `stow .` from the repo root.

## Build/Install Commands

```bash
# Install all dotfiles
make install

# Or run the install script directly
./bin/install.sh
```

## Code Formatting

### Lua (Neovim Config)

Use **StyLua** for formatting Lua files:

```bash
# Format all Lua files
stylua .

# Check formatting without making changes
stylua --check .
```

Configuration is in `stylua.toml`:
- Column width: 120
- Indent: 2 spaces
- Quote style: AutoPreferDouble
- Call parentheses: Always

### Fish Shell

Fish scripts don't have a dedicated linter configured. Follow existing patterns:
- Use 4-space indentation
- Use `function` for defining functions
- Use `abbr` for abbreviations/aliases
- Functions use snake_case naming

### Bash/Shell

Follow existing patterns in `bin/`:
- Use `set -euo pipefail` for strict mode
- Use snake_case for variables and functions
- 2-space indentation for consistency with Lua
- Quote all variables: `"$variable"`
- Use `[[ ]]` for tests, not `[ ]`

## Code Style Guidelines

### General

1. **File Structure**: Keep related configs in named directories (e.g., `nvim/`, `fish/`, `scripts/`)
2. **Comments**: Use comments to explain non-obvious logic
3. **Error Handling**: Always check for command existence with `command -v` or `which`
4. **Local vs Global**: Prefer local variables in functions

### Lua (Neovim)

1. **Type Annotations**: Use EmmyLua annotations for functions and variables
   ```lua
   ---@param path string
   ---@return boolean
   function M.validate(path)
   ```

2. **Module Pattern**: Return a table at the end of modules
   ```lua
   local M = {}
   -- ... functions ...
   return M
   ```

3. **Naming**: Use PascalCase for module tables, snake_case for functions

4. **Imports**: Group imports at the top, use local variables
   ```lua
   local uv = vim.uv
   local utils = require("utils")
   ```

5. **Plugin Configuration**: Place LSP configs in `nvim/lsp/`, plugin configs inline in `init.lua`

### Fish

1. **Variables**: Use `-l` for local, `-g` for global, `-U` for universal
2. **Conditionals**: Use `test` with proper quoting
3. **Functions**: Define with `function name; ...; end` format

### Bash

1. **Utilities**: Source `bin/utils.sh` for `step`, `success`, `error`, `info` functions
2. **Machine Detection**: Use the `MACHINE` variable (linux/darwin)
3. **Safe Execution**: Always check if files/commands exist before using them

## Testing

This repository does not have automated tests. When making changes:

1. Test shell scripts with `bash -n script.sh` for syntax checking
2. Test Fish scripts with `fish --no-execute script.fish`
3. For Neovim Lua: open nvim and check for errors with `:messages`
4. Run `make install` in a test environment before committing

## Symlink Management (Stow)

- Stow targets `~/.config` (configured in `.stowrc`)
- Ignored files are listed in `.stow-local-ignore`
- Some files are manually symlinked in `bin/install.sh` (e.g., `~/.ssh/config`)

## Key Files Reference

- `bin/install.sh` - Main installation script
- `bin/utils.sh` - Shell utility functions
- `bin/tools.sh` - Tool installation logic
- `stylua.toml` - Lua formatter configuration
- `.stowrc` - Stow configuration
- `.stow-local-ignore` - Files excluded from stowing

## Dependencies

Required tools (installed by `bin/tools.sh`):
- fish - Shell
- nvim - Editor
- tmux - Terminal multiplexer
- stow - Symlink manager
- jj - Version control (Jujutsu)

Optional but used:
- zoxide - Smart directory jumping
- mcfly - Shell history search
- eza - Modern ls replacement
- bat - Syntax-highlighting cat

## Adding New Configurations

1. Create a new directory for the tool
2. Add configuration files inside
3. Add to `.stow-local-ignore` if it shouldn't be stowed
4. Update `bin/install.sh` if special installation steps needed
5. Test with `stow --no .` first (dry run)
