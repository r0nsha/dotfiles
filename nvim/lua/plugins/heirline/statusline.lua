local cond = require("heirline.conditions")
local icons = require("config.icons")
local utils = require("heirline.utils")

local redrawstatus = vim.schedule_wrap(function() vim.cmd.redrawstatus() end)

local function active_fg() return cond.is_active() and "fg_active" or "fg_inactive" end

local function update_on(events)
  return vim.tbl_extend("force", {
    "WinEnter",
    "BufWinEnter",
    "WinLeave",
    "BufWinLeave",
    "FocusGained",
    "FocusLost",
    callback = redrawstatus,
  }, events)
end

local Align = { provider = "%=" }

---@param n? number
local Space = function(n) return { provider = string.rep(" ", n or 1) } end

local _, hydra = pcall(require, "hydra.statusline")

local Mode = {
  condition = cond.is_active,
  init = function(self)
    self.hydra_mode = hydra and hydra.get_name() or nil
    self.mode = vim.fn.mode(1)
  end,
  static = {
    mode_names = {
      n = "NOR",
      i = "INS",
      v = "VIS",
      V = "VIS",
      ["\22"] = "VIS",
      s = "SEL",
      S = "SEL",
      ["\19"] = "SEL",
      R = "REP",
      c = "CMD",
      t = "TRM",
      ["!"] = "!",
    },
  },
  provider = function(self)
    local name = self.hydra_mode
    if not name then
      local mode_char = self.mode:sub(1, 1)
      name = self.mode_names[mode_char] or mode_char:upper()
    end
    return "%-5(" .. name .. "%)"
  end,
  hl = function() return { fg = hydra and hydra.get_color() or active_fg() } end,
  update = update_on({ "ModeChanged", "User" }),
}

local FileBlock = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
    self.is_scratch_buffer = self.filename == ""
  end,
  hl = function()
    local color = vim.bo.modified and "blue" or active_fg()
    if not vim.bo.modifiable or vim.bo.readonly then color = "gray" end
    return { fg = color }
  end,
}

local FileIcon = {
  init = function(self)
    if self.is_scratch_buffer then
      self.icon = nil
      return
    end

    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ":e")
    local icon, hl = require("mini.icons").get("extension", extension)
    local hl_data = vim.api.nvim_get_hl(0, { name = hl, link = false })
    self.icon = icon
    self.icon_color = hl_data and hl_data.fg
  end,
  provider = function(self) return self.icon and (self.icon .. " ") end,
  hl = function(self) return { fg = self.icon_color } end,
}

local FileName = {
  provider = function(self)
    local filename = vim.fn.fnamemodify(self.filename, ":.")
    if filename == "" then return "[No Name]" end
    if not cond.width_percent_below(#filename, 0.5) then filename = vim.fn.pathshorten(filename) end
    return filename
  end,
  hl = function(self) return { fg = self.filename == "" and "gray" or active_fg() } end,
}

local FileNameModifer = {
  hl = function()
    if vim.bo.modified then return { fg = active_fg(), bold = true, force = true } end
  end,
}

local FileFlags = {
  {
    condition = function() return vim.bo.modified end,
    provider = " [+]",
    hl = function() return { fg = active_fg(), bold = true } end,
  },
  {
    condition = function() return not vim.bo.modifiable or vim.bo.readonly end,
    provider = " ",
    hl = function() return { fg = "gray" } end,
  },
}

FileBlock = utils.insert(FileBlock, FileIcon, utils.insert(FileNameModifer, FileName), FileFlags, { provider = "%<" })

---@param type "error" | "warning" | "info" | "hint"
---@return table
local function diagnostic_provider(type)
  return {
    provider = function(self)
      local count = self[type .. "s"]
      local icon = icons[type]
      return count > 0 and (icon .. " " .. count .. " ")
    end,
    hl = function() return { fg = "diag_" .. type } end,
  }
end

local Diagnostics = {
  condition = cond.has_diagnostics,
  init = function(self)
    local counts = vim.diagnostic.count(0)
    self.errors = counts[vim.diagnostic.severity.ERROR] or 0
    self.warnings = counts[vim.diagnostic.severity.WARN] or 0
    self.hints = counts[vim.diagnostic.severity.HINT] or 0
    self.infos = counts[vim.diagnostic.severity.INFO] or 0
  end,

  diagnostic_provider("error"),
  diagnostic_provider("warning"),
  diagnostic_provider("info"),
  diagnostic_provider("hint"),

  update = update_on({ "DiagnosticChanged", "BufEnter" }),
}

local Lsp = {
  condition = function() return cond.is_active() and cond.lsp_attached() end,
  {
    provider = function()
      local names = {}

      for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
        table.insert(names, server.name)
      end

      local max_servers = 1
      local display_names = {}
      local extra_count = #names - max_servers

      for i = 1, math.min(max_servers, #names) do
        table.insert(display_names, names[i])
      end

      if extra_count > 0 then table.insert(display_names, string.format("+%d", extra_count)) end

      return table.concat(display_names, ", ")
    end,
    hl = function() return { fg = "gray" } end,
    update = update_on({ "LspAttach", "LspDetach" }),
  },
  Space(2),
}

local LspProgress = {
  provider = function() return vim.ui.progress_status() end,
  hl = { fg = "gray" },
  update = update_on({ "LspProgress" }),
}

local function in_visual_mode() return vim.api.nvim_get_mode().mode:lower() == "v" end

local Selection = {
  provider = function()
    if not in_visual_mode() then return nil end

    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    local lines = math.abs(end_line - start_line) + 1
    local cols = vim.fn.wordcount().visual_chars

    local format = string.format("%2d,%2d sel  ", lines, cols)
    return "%8(" .. format .. "%)"
  end,
}

local Position = { provider = "%-8(%l:%c%)" }
local Percent = { provider = "%3(%P%)" }

local Ruler = {
  condition = cond.is_active,
  Selection,
  Position,
  Percent,
}

local Left = {
  Space(1),
  Mode,
  Space(1),
  FileBlock,
  Space(1),
}

local Right = {
  Space(1),
  Diagnostics,
  Space(1),
  LspProgress,
  Lsp,
  Ruler,
  Space(1),
}

local disable_for = {
  filetype = { "dashboard", "trouble", "Glance" },
}

local function is_statusline_disabled() return not cond.buffer_matches(disable_for) end

return {
  condition = is_statusline_disabled,
  Left,
  Align,
  Right,
  hl = function() return { fg = active_fg() } end,
}
