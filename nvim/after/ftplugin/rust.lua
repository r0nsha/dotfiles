local notify = vim.schedule_wrap(vim.notify)

local bufnr = vim.api.nvim_get_current_buf()

local function rust_analyzer_client() return vim.lsp.get_clients({ bufnr = bufnr, name = "rust_analyzer" })[1] end

---@param on_exit fun(result: vim.SystemCompleted)?
---@return vim.SystemObj
local function list_rustup_targets(on_exit)
  return vim.system({ "rustup", "target", "list", "--installed" }, { text = true }, on_exit)
end

---@param result vim.SystemCompleted
---@return string[]?, string?
local function parse_rustup_targets(result)
  if result.code ~= 0 then return nil, result.stderr ~= "" and result.stderr or "failed to load rustup targets" end

  local targets = {}
  for _, line in ipairs(vim.split(result.stdout, "\n", { trimempty = true })) do
    targets[#targets + 1] = line
  end
  return targets, nil
end

---@param client vim.lsp.Client
---@param target string
local function set_target(client, target)
  ---@type lspconfig.settings.rust_analyzer
  local settings = client.config.settings or {}
  settings["rust-analyzer"] = settings["rust-analyzer"] or {}
  settings["rust-analyzer"].cargo = settings["rust-analyzer"].cargo or {}
  settings["rust-analyzer"].cargo.target = target
  client.config.settings = settings
  client:notify("workspace/didChangeConfiguration", { settings = settings })
end

---@param client vim.lsp.Client
local function select_target(client)
  list_rustup_targets(function(result)
    local targets, err = parse_rustup_targets(result)
    if not targets then
      notify(err, vim.log.levels.ERROR)
      return
    end

    vim.schedule(function()
      vim.ui.select(targets, { prompt = "Rust target" }, function(choice)
        if choice then set_target(client, choice) end
      end)
    end)
  end)
end

vim.api.nvim_buf_create_user_command(bufnr, "RustTarget", function(opts)
  local client = rust_analyzer_client()
  if not client then
    notify("rust-analyzer not attached", vim.log.levels.ERROR)
    return
  end

  if opts.args == "" then
    select_target(client)
    return
  end

  set_target(client, opts.args)
end, {
  nargs = "?",
  desc = "Set rust-analyzer cargo target",
  complete = function(args)
    local targets = parse_rustup_targets(list_rustup_targets():wait())
    if not targets then return {} end
    return vim.tbl_filter(function(target) return vim.startswith(target, args) end, targets)
  end,
})
