local cond = require("heirline.conditions")
local icons = require("config.icons")
local utils = require("heirline.utils")

local function active_fg()
  return cond.is_active() and "fg_active" or "fg_inactive"
end

local function update_on(events)
  return vim.tbl_extend("keep", events, {
    "WinEnter",
    "BufWinEnter",
    "WinLeave",
    "BufWinLeave",
    "FocusGained",
    "FocusLost",
    callback = vim.schedule_wrap(function()
      vim.cmd("redrawstatus")
    end),
  })
end

local Align = { provider = "%=" }

---@param n? number
local Space = function(n)
  return { provider = string.rep(" ", n or 1) }
end

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
      no = "NOR?",
      nov = "NOR?",
      noV = "NOR?",
      ["no\22"] = "NOR?",
      niI = "NORi",
      niR = "NORr",
      niV = "NORv",
      nt = "NORt",
      v = "VIS",
      vs = "VIS",
      V = "VIL",
      Vs = "VIS",
      ["\22"] = "VIB",
      ["\22s"] = "VIB",
      s = "SEL",
      S = "SEL",
      ["\19"] = "SEB",
      i = "INS",
      ic = "INSc",
      ix = "INSx",
      R = "REP",
      Rc = "REPc",
      Rx = "REPx",
      Rv = "REPv",
      Rvc = "REPvc",
      Rvx = "REPvx",
      c = "CMD",
      cv = "EX",
      r = "...",
      rm = "RM",
      ["r?"] = "?",
      ["!"] = "!",
      t = "TERM",
    },
    mode_colors = {
      n = "fg",
      i = "green",
      v = "blue",
      V = "blue",
      ["\22"] = "blue",
      c = "orange",
      s = "purple",
      S = "purple",
      ["\19"] = "purple",
      R = "orange",
      r = "orange",
      ["!"] = "gray",
      t = "gray",
    },
  },
  provider = function(self)
    local name = self.hydra_mode or self.mode_names[self.mode]
    return " %-5(" .. name .. "%)"
  end,
  hl = function(self)
    local hydra_color = hydra and hydra.get_color() or nil
    if hydra_color then
      return { fg = hydra_color, bold = false }
    end

    local mode = self.mode:sub(1, 1) -- get only the first mode character
    local fg = cond.is_active() and self.mode_colors[mode] or "fg_inactive"
    return { fg = fg, bold = false }
  end,
  update = update_on({ "ModeChanged", "User" }),
}

local FileBlock = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
    self.is_scratch_buffer = self.filename == ""
  end,
  hl = function()
    local color = vim.bo.modified and "blue" or active_fg()

    if not vim.bo.modifiable or vim.bo.readonly then
      color = "gray"
    end

    return { fg = color }
  end,
}

local FileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ":e")
    local icon, hl = require("mini.icons").get("extension", extension)
    local hl_data = vim.api.nvim_get_hl(0, { name = hl })
    self.icon = icon
    self.icon_color = hl_data and hl_data.fg
  end,
  provider = function(self)
    return self.icon and (self.icon .. " ")
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
}

local FileName = {
  provider = function(self)
    local filename = vim.fn.fnamemodify(self.filename, ":.")
    if filename == "" then
      return "[No Name]"
    end
    if not cond.width_percent_below(#filename, 0.5) then
      filename = vim.fn.pathshorten(filename)
    end
    return filename
  end,
  hl = function(self)
    return { fg = self.filename == "" and "gray" or active_fg() }
  end,
}

local FileNameModifer = {
  hl = function()
    if vim.bo.modified then
      return { fg = active_fg(), bold = true, force = true }
    end
  end,
}

local FileFlags = {
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = " [+]",
    hl = function()
      return { fg = active_fg(), bold = true }
    end,
  },
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = " ",
    hl = function()
      return { fg = "gray" }
    end,
  },
}

FileBlock = utils.insert(FileBlock, FileIcon, utils.insert(FileNameModifer, FileName), FileFlags, { provider = "%<" })

local function nonzero(n)
  return n ~= nil and n ~= 0
end

local Git = {
  condition = function()
    return cond.is_active() and (cond.is_git_repo() or vim.b.minidiff_summary)
  end,

  init = function(self)
    if vim.b.gitsigns_status_dict then
      self.status_dict = vim.b.gitsigns_status_dict
    elseif vim.b.minidiff_summary then
      if not self.status_dict then
        self.status_dict = { head = "" }
      end

      self.status_dict.added = vim.b.minidiff_summary.add
      self.status_dict.removed = vim.b.minidiff_summary.delete
      self.status_dict.changed = vim.b.minidiff_summary.change

      vim.system({ "git", "rev-parse", "--abbrev-ref", "HEAD" }, {
        text = true,
        cwd = vim.fn.getcwd(),
      }, function(result)
        local head
        if result.code == 0 then
          local output = result.stdout:gsub("%s+", "")
          head = output ~= "HEAD" and output or "(detached)"
        else
          head = ""
        end

        if head ~= self.status_dict.head then
          self.status_dict.head = head
          vim.schedule(function()
            vim.cmd.redrawstatus()
          end)
        end
      end)
    end

    if self.status_dict then
      self.has_changes = nonzero(self.status_dict.added)
        or nonzero(self.status_dict.removed)
        or nonzero(self.status_dict.changed)
    end
  end,

  hl = function()
    return { fg = "gray" }
  end,

  {
    provider = function(self)
      return " " .. self.status_dict.head
    end,
  },

  {
    condition = function(self)
      return self.has_changes
    end,

    Space(),
    {
      condition = function(self)
        return self.status_dict.added > 0
      end,
      provider = function(self)
        return "+" .. self.status_dict.added
      end,
      hl = function()
        return { fg = "git_add" }
      end,
    },
    {
      condition = function(self)
        return self.status_dict.changed > 0
      end,
      provider = function(self)
        local space = self.status_dict.added > 0 and " " or ""
        return space .. "~" .. self.status_dict.changed
      end,
      hl = function()
        return { fg = "git_change" }
      end,
    },
    {
      condition = function(self)
        return self.status_dict.removed > 0
      end,
      provider = function(self)
        local space = (self.status_dict.added > 0 or self.status_dict.changed > 0) and " " or ""
        return space .. "-" .. self.status_dict.removed
      end,
      hl = function()
        return { fg = "git_del" }
      end,
    },
  },

  update = update_on({
    "User",
    pattern = { "GitSignsUpdate", "GitSignsChanged", "MiniDiffUpdated" },
  }),
}

---@param type "error" | "warning" | "info" | "hint"
---@return table
local function diagnostic_provider(type)
  return {
    provider = function(self)
      local count = self[type .. "s"]
      local icon = icons[type]
      return count > 0 and (icon .. " " .. count .. " ")
    end,
    hl = function()
      return { fg = "diag_" .. type }
    end,
  }
end

local Diagnostics = {
  condition = cond.has_diagnostics,
  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.infos = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,

  diagnostic_provider("error"),
  diagnostic_provider("warning"),
  diagnostic_provider("info"),
  diagnostic_provider("hint"),

  update = update_on({ "DiagnosticChanged", "BufEnter" }),
}

local Lsp = {
  condition = function()
    return cond.is_active() and cond.lsp_attached()
  end,
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

      if extra_count > 0 then
        table.insert(display_names, string.format("+%d", extra_count))
      end

      return "[" .. table.concat(display_names, ", ") .. "]"
    end,
    hl = function()
      return { fg = "gray" }
    end,
    update = update_on({ "LspAttach", "LspDetach" }),
  },
  Space(2),
}

local function in_visual_mode()
  return vim.api.nvim_get_mode().mode:lower() == "v"
end

local Selection = {
  provider = function()
    if not in_visual_mode() then
      return nil
    end

    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    local lines = math.abs(end_line - start_line) + 1
    local cols = vim.fn.wordcount().visual_chars

    local format = string.format("%2d,%2d sel", lines, cols)
    return "%8(" .. format .. "%)"
  end,
}

local Position = { provider = "%-8(%l:%c%)" }
local Percent = { provider = "%3(%P%)" }

local Ruler = {
  condition = cond.is_active,
  Selection,
  Space(2),
  Position,
  Percent,
}

local Left = {
  Mode,
  Space(1),
  FileBlock,
  Space(1),
  Git,
}

local Right = {
  Space(1),
  Diagnostics,
  Space(1),
  Lsp,
  Ruler,
  Space(1),
}

local disable_for = {
  filetype = { "dashboard", "Neogit*", "trouble", "Glance" },
}

local function is_statusline_disabled()
  return not cond.buffer_matches(disable_for)
end

return {
  condition = is_statusline_disabled,
  Left,
  Align,
  Right,
  hl = function()
    return { fg = active_fg() }
  end,
}
