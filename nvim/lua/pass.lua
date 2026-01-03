local M = {}

---@param var string
---@param pass_name string
local function read(var, pass_name)
  local Job = require "plenary.job"

  ---@diagnostic disable-next-line: missing-fields
  local j = Job:new {
    command = "pass",
    args = { "show", pass_name },
  }

  j:after_success(function()
    local result = table.concat(j:result(), "\n")
    vim.schedule(function()
      vim.env[var] = result
    end)
  end)

  -- j:after_failure(function()
  --   local error = table.concat(j:stderr_result(), "\n")
  --   vim.schedule(function()
  --     vim.notify(string.format("Failed retrieving `%s` from `pass`. %s", pass_name, error))
  --   end)
  -- end)

  j:start()
end

function M.load()
  read("CODESTRAL_API_KEY", "mistral/codestral")
  read("GEMINI_API_KEY", "google/gemini")
  read("TAVILY_API_KEY", "tavily/personal")
end

vim.api.nvim_create_user_command("PassLoad", M.load, {})

return M
