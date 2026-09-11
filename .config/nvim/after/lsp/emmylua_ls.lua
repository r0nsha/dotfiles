return {
  on_init = function(client)
    -- If the workspace has its own emmylua_ls/lua_ls config file, defer to it.
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath("config")
        and (vim.uv.fs_stat(path .. "/.emmyrc.json") or vim.uv.fs_stat(path .. "/.luarc.json"))
      then
        client.config.settings = {}
      end
    end
  end,
  settings = {
    emmylua = {
      -- Tell the server which Lua you're using (usually LuaJIT, for Neovim).
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim", "swayimg" } },
      -- Make the server aware of Neovim runtime files.
      workspace = {
        -- `lua` search includes VIMRUNTIME/lua, this config's lua/, and every
        -- plugin's lua/ dir on 'runtimepath' (incl. nvim-lspconfig's LSP
        -- settings type annotations).
        library = vim.list_extend(
          { vim.env.VIMRUNTIME },
          vim.api.nvim_get_runtime_file("lua", true)
        ),
        -- Or pull in all of 'runtimepath'. May be slower! https://github.com/neovim/nvim-lspconfig/issues/3189
        -- library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
}
