return {
  "rebelot/heirline.nvim",
  dependencies = { "Zeioth/heirline-components.nvim" },
  config = function()
    local heirline_components = require "heirline-components.all"
    heirline_components.init.subscribe_to_events()

    local conditions = require "heirline.conditions"
    local utils = require "heirline.utils"
    local icons = require("utils").icons

    local function setup_colors()
      ---@param name string
      ---@param field? string
      local function hl_color(name, field)
        local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
        return field and hl[field] or hl.fg
      end

      return {
        bg_inactive = hl_color("Normal", "bg"),
        bg_active = hl_color("StatusLineNC", "bg"),
        fg_active = hl_color "Normal",
        fg_inactive = hl_color "NonText",
        green = hl_color "String",
        blue = hl_color "Function",
        gray = hl_color "NonText",
        orange = hl_color "Constant",
        special = hl_color "Special",
        purple = hl_color "Keyword",
        diag_hint = hl_color "DiagnosticHint",
        diag_info = hl_color "DiagnosticInfo",
        diag_warning = hl_color "DiagnosticWarn",
        diag_error = hl_color "DiagnosticError",
        git_del = hl_color "GitSignsDelete",
        git_add = hl_color "GitSignsAdd",
        git_change = hl_color "GitSignsChange",
      }
    end

    local function active_bg()
      return conditions.is_active() and "bg_active" or "bg_inactive"
    end

    local function active_fg()
      return conditions.is_active() and "fg_active" or "fg_inactive"
    end

    local function update_on(events)
      return vim.tbl_extend(
        "keep",
        events,
        { "WinEnter", "BufWinEnter", "WinLeave", "BufWinLeave", "FocusGained", "FocusLost" }
      )
    end

    local Align = { provider = "%=" }

    local Space = function(n)
      return { provider = string.rep(" ", n) }
    end

    local Pad = function(child, n)
      return { Space(n), child, Space(n) }
    end

    local Mode = {
      init = function(self)
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
        return "%5(" .. self.mode_names[self.mode] .. "%) "
      end,
      hl = function(self)
        local mode = self.mode:sub(1, 1) -- get only the first mode character
        local fg = conditions.is_active() and self.mode_colors[mode] or "fg_inactive"
        return { fg = fg, bold = false }
      end,
      update = update_on { "ModeChanged" },
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
        self.icon, self.icon_color =
          require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
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
        if not conditions.width_percent_below(#filename, 0.5) then
          filename = vim.fn.pathshorten(filename)
        end
        return filename
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

    FileBlock =
      utils.insert(FileBlock, FileIcon, utils.insert(FileNameModifer, FileName), FileFlags, { provider = "%<" })

    local function nonzero(n)
      return n ~= nil and n ~= 0
    end

    local Git = {
      condition = conditions.is_git_repo,

      init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = nonzero(self.status_dict.added)
          or nonzero(self.status_dict.removed)
          or nonzero(self.status_dict.changed)
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

        { provider = "(" },
        {
          provider = function(self)
            local count = self.status_dict.added or 0
            return count > 0 and ("+" .. count)
          end,
          hl = function()
            return { fg = "git_add" }
          end,
        },
        {
          provider = function(self)
            local count = self.status_dict.removed or 0
            return count > 0 and ("-" .. count)
          end,
          hl = function()
            return { fg = "git_del" }
          end,
        },
        {
          provider = function(self)
            local count = self.status_dict.changed or 0
            return count > 0 and ("~" .. count)
          end,
          hl = function()
            return { fg = "git_change" }
          end,
        },
        { provider = ")" },
      },
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
      condition = conditions.has_diagnostics,

      init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.infos = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
      end,

      update = update_on { "DiagnosticChanged", "BufEnter" },

      diagnostic_provider "error",
      diagnostic_provider "warning",
      diagnostic_provider "info",
      diagnostic_provider "hint",
    }

    local Lsp = {
      condition = conditions.lsp_attached,
      update = update_on { "LspAttach", "LspDetach" },

      provider = function()
        local names = {}

        for _, server in pairs(vim.lsp.get_clients { bufnr = 0 }) do
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
    }

    local function in_visual_mode()
      return vim.api.nvim_get_mode().mode:lower() == "v"
    end

    local Ruler = {
      { provider = "%7(%l/%-3L%)" },
      {
        provider = function()
          if not in_visual_mode() then
            return " [col %2c]"
          end

          local start_line = vim.fn.line "v"
          local end_line = vim.fn.line "."
          local lines = math.abs(end_line - start_line) + 1
          local cols = vim.fn.wordcount().visual_chars

          return string.format(" [sel %2d,%2d]", lines, cols)
        end,
      },
      hl = function(_)
        return { fg = in_visual_mode() and "blue" or active_fg() }
      end,
    }

    -- local Time = {
    --   provider = function()
    --     return icons.clock .. " " .. os.date "%H:%M"
    --   end,
    -- }

    local Left = {
      Mode,
      FileBlock,
      Space(1),
      Git,
    }

    local Right = {
      Pad(Diagnostics, 1),
      Lsp,
      Space(3),
      Ruler,
      -- Space(1),
      -- Time,
      Space(2),
    }

    local disable_for = {
      filetype = { "dashboard", "Neogit*", "trouble", "Glance" },
    }

    local function is_statusline_disabled()
      return not conditions.buffer_matches(disable_for)
    end

    local opts = {
      opts = { colors = setup_colors },
    }

    opts.statusline = {
      condition = is_statusline_disabled,
      Left,
      Align,
      Right,
      hl = function()
        return { bg = active_bg(), fg = active_fg() }
      end,
    }

    opts.statuscolumn = {
      heirline_components.component.signcolumn(),
      heirline_components.component.foldcolumn(),
      heirline_components.component.numbercolumn(),
    }

    require("heirline").setup(opts)

    vim.api.nvim_create_autocmd({ "ColorScheme", "BufWinEnter" }, {
      group = vim.api.nvim_create_augroup("Heirline", { clear = true }),
      callback = function()
        utils.on_colorscheme(setup_colors)
      end,
    })
  end,
}
