local augroup = require("augroup")

local exit_term_mode = [[<C-\><C-n>]]
vim.keymap.set("t", "<C-Esc>", exit_term_mode, { desc = "Exit terminal mode" })
vim.keymap.set("t", "<S-Esc>", exit_term_mode, { desc = "Exit terminal mode" })
vim.keymap.set("t", "<A-Esc>", exit_term_mode, { desc = "Exit terminal mode" })

-- :terminal-nested Nvim:
if vim.env.NVIM then
  ---@return integer?
  local function parent_chan()
    local ok, chan = pcall(vim.fn.sockconnect, "pipe", vim.env.NVIM, { rpc = true })
    if not ok then
      vim.notify(("failed to create channel to $NVIM: %s"):format(chan))
      return nil
    end
    return chan --[[@as integer?]]
  end

  local didset = false
  local chan = assert(parent_chan())
  local function map_parent(lhs)
    -- Map `lhs` in the parent so it gets sent to the child (this) Nvim.
    local map = vim.rpcrequest(
      chan,
      "nvim_exec_lua",
      [[return vim.fn.maparg(..., 't', false, true)]],
      { lhs }
    ) --[[@as table<string,any>]]
    if map.rhs == exit_term_mode then
      vim.rpcrequest(
        chan,
        "nvim_exec_lua",
        [[vim.keymap.set('t', ..., '<Esc>', {buffer=0})]],
        { lhs }
      )
      didset = true
    end
  end
  map_parent("<C-Esc>")
  map_parent("<S-Esc>")
  map_parent("<A-Esc>")
  vim.fn.chanclose(chan)

  -- Restore the mapping(s) on VimLeave.
  if didset then
    vim.api.nvim_create_autocmd("VimLeave", {
      group = augroup,
      desc = "Restore parent nvim mappings",
      callback = function()
        local chan2 = assert(parent_chan())
        vim.rpcrequest(
          chan2,
          "nvim_exec2",
          [=[
          silent! tunmap <buffer> <C-Esc>
          silent! tunmap <buffer> <S-Esc>
          silent! tunmap <buffer> <A-Esc>
        ]=],
          {}
        )
      end,
    })
  end
end
