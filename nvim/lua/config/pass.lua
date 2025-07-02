local M = {}

---@param pass_name string
function M.read(var, pass_name)
  local Job = require("plenary.job")
  local notify = vim.schedule_wrap(vim.notify)

  ---@diagnostic disable-next-line: missing-fields
  local j = Job:new({
    command = "pass",
    args = { "show", pass_name },
  })

  j:after_success(function()
    local result = table.concat(j:result(), "\n")
    vim.schedule(function()
      vim.env[var] = result
    end)
  end)

  j:after_failure(function()
    local error = table.concat(j:stderr_result(), "\n")
    notify(string.format("Failed retrieving `%s` from `pass`. %s", pass_name, error))
  end)

  j:start()
end

---@param tbl table<string, string>
function M.read_all(tbl)
  for var, pass_name in pairs(tbl) do
    M.read(var, pass_name)
  end
end

function M.load()
  M.read_all({
    CODESTRAL_API_KEY = "mistral/codestral",
    GEMINI_API_KEY = "google/gemini",
  })
end

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("CustomPass", { clear = true }),
  pattern = "LazyLoad",
  callback = function(args)
    local plugin = args.data
    if plugin == "plenary.nvim" then
      M.load()
    end
  end,
})

vim.api.nvim_create_user_command("PassLoad", M.load, {})

return M
