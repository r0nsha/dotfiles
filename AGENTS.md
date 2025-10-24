# Agent Guidelines for Dotfiles Repository

## Build/Lint/Test Commands

This is a dotfiles repository with no traditional build process. Use these commands for validation:

- **Lint Lua**: `stylua --check nvim/`
- **Format Lua**: `stylua nvim/`
- **Lint Fish**: `fish --no-execute **/*.fish` (check syntax)
- **Lint Shell**: `shellcheck bin/*.sh scripts/*.fish` (if available)

No test framework configured. Manual testing via `make install` for integration.

## Version Control

This repository uses **Jujutsu (jj)** as the version control system. Always use jj commands instead of git:

- **Status**: `jj status`
- **Diff**: `jj diff`
- **Log**: `jj log`
- **Commit**: `jj commit -m "message"`
- **Add files**: `jj add <files>`
- **Push**: `jj git push`

## Code Style Guidelines

### Lua (Neovim config)

- **Formatting**: stylua with 120 column width, 2-space indentation
- **Imports**: Group requires at top, sort automatically enabled
- **Naming**: snake_case for variables/functions, PascalCase for modules
- **Error handling**: Use pcall for optional requires, explicit error messages

### Shell Scripts (Bash/Fish)

- **Bash**: `set -euo pipefail`, descriptive variable names, functions for reuse
- **Fish**: Simple functions, avoid complex logic, use `set -l` for locals
- **Error handling**: Check command success, provide clear error messages
- **Comments**: Brief comments for complex operations

### General

- **No trailing whitespace**: Formatters handle this automatically
- **Consistent quoting**: Double quotes for strings, single for literals
- **Modular config**: Separate concerns into different files
- **Documentation**: Update README for significant changes

### Language Support

Primary languages: Lua, Fish, Bash. LSP configured for Python (ruff), JS/TS (biome/prettier), Rust, Go, etc.

