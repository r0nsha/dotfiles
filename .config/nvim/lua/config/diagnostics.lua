-- --- @param diagnostic? vim.Diagnostic
-- --- @param bufnr integer
-- local function on_jump(diagnostic, bufnr)
--   if diagnostic then
--     vim.diagnostic.open_float({
--       bufnr = bufnr,
--       namespace = diagnostic.namespace,
--       scope = "cursor",
--       source = "if_many",
--     })
--   end
-- end

-- vim.diagnostic.config({
--   -- jump = { on_jump = on_jump },
--   virtual_text = false,
-- })

local qf_severity = {
  E = vim.diagnostic.severity.ERROR,
  W = vim.diagnostic.severity.WARN,
  I = vim.diagnostic.severity.INFO,
  H = vim.diagnostic.severity.HINT,
}

---@param opts vim.diagnostic.GetOpts?
local function set_sorted_qflist(opts)
  opts = vim.tbl_extend("force", { open = false }, opts or {})
  local diagnostics = vim.diagnostic.get(nil, opts)
  if #diagnostics == 0 then
    vim.notify("No diagnostics found", vim.log.levels.INFO)
    vim.fn.setqflist({}, " ", { items = {}, title = "Diagnostics" })
    vim.cmd.cclose()
    return
  end
  local items = vim.diagnostic.toqflist(diagnostics)
  table.sort(
    items,
    function(a, b) return (qf_severity[a.type] or math.huge) < (qf_severity[b.type] or math.huge) end
  )
  vim.fn.setqflist({}, " ", { items = items, title = "Diagnostics" })
  vim.cmd.copen()
end

vim.keymap.set("n", "grq", set_sorted_qflist, { desc = "Show diagnostics" })
vim.keymap.set("n", "grQ", function()
  vim.ui.select(
    { "Error", "Warn", "Info", "Hint" },
    { prompt = "Select minimum severity" },
    function(severity)
      if not severity then return end
      set_sorted_qflist({
        severity = {
          min = vim.diagnostic.severity[severity:upper()],
          max = vim.diagnostic.severity.ERROR,
        },
      } --[[@as vim.diagnostic.GetOpts]])
    end
  )
end, { desc = "Show diagnostics (filtered)" })
