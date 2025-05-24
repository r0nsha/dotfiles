return {
  {
    "rebelot/heirline.nvim",
    dependencies = { "rebelot/kanagawa.nvim" },
    config = function()
      local conditions = require "heirline.conditions"
      local utils = require "heirline.utils"
      local icons = require("config.utils").icons

      local function setup_colors()
        local colors = require("kanagawa.colors").setup()

        vim.api.nvim_set_hl(0, "Statusline", { bg = colors.theme.ui.bg, fg = colors.theme.ui.fg_dim })

        return {
          bg = colors.theme.ui.bg,
          fg = colors.theme.ui.fg_dim,
          green = colors.theme.syn.string,
          blue = colors.theme.syn.fun,
          gray = colors.theme.ui.nontext,
          orange = colors.theme.syn.constant,
          special = colors.theme.ui.special,
          purple = colors.theme.syn.keyword,
          diag_hint = colors.theme.diag.hint,
          diag_info = colors.theme.diag.info,
          diag_warning = colors.theme.diag.warning,
          diag_error = colors.theme.diag.error,
          git_del = colors.theme.vcs.removed,
          git_add = colors.theme.vcs.added,
          git_change = colors.theme.vcs.changed,
        }
      end

      local Align = { provider = "%=" }

      local Space = function(n)
        return { provider = string.rep(" ", n) }
      end

      local Pad = function(child, n)
        return { Space(n), child, Space(n) }
      end

      ---@param pad? number
      local Separator = function(pad)
        local sep = { provider = "│", hl = utils.get_highlight "Whitespace" }

        if pad then
          sep = Pad(sep, pad)
        end

        return sep
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
          return " %-3(" .. self.mode_names[self.mode] .. "%) "
        end,
        hl = function(self)
          local mode = self.mode:sub(1, 1) -- get only the first mode character
          return { bg = "bg", fg = self.mode_colors[mode], bold = false }
        end,
        update = { "ModeChanged" },
      }

      local FileBlock = {
        init = function(self)
          self.filename = vim.api.nvim_buf_get_name(0)
          self.is_scratch_buffer = self.filename == ""
        end,
        hl = function()
          local color = vim.bo.modified and "blue" or "fg"

          if not vim.bo.modifiable or vim.bo.readonly then
            color = "gray"
          end

          return { bg = "bg", fg = color }
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
          if not conditions.width_percent_below(#filename, 0.75) then
            filename = vim.fn.pathshorten(filename)
          end
          return filename
        end,
      }

      local FileNameModifer = {
        hl = function()
          if vim.bo.modified then
            return { fg = "fg", bold = true, force = true }
          end
        end,
      }

      local FileFlags = {
        {
          condition = function()
            return vim.bo.modified
          end,
          provider = " [+]",
          hl = { fg = "fg", bold = true },
        },
        {
          condition = function()
            return not vim.bo.modifiable or vim.bo.readonly
          end,
          provider = " ",
          hl = { fg = "gray" },
        },
      }

      local FileType = {
        provider = function(self)
          local ext = self.filename:match "%.([^.]+)$"
          local type = vim.bo.filetype

          if ext == type or self.is_scratch_buffer then
            return ""
          end

          return string.format(" (%s)", vim.bo.filetype)
        end,
        hl = { fg = utils.get_highlight("NonText").fg, bold = false },
      }

      FileBlock = utils.insert(
        FileBlock,
        FileIcon,
        utils.insert(FileNameModifer, FileName),
        FileFlags,
        FileType,
        { provider = "%<" }
      )

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

        hl = { fg = "special" },

        Separator(1),

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
            hl = { fg = "git_add" },
          },
          {
            provider = function(self)
              local count = self.status_dict.removed or 0
              return count > 0 and ("-" .. count)
            end,
            hl = { fg = "git_del" },
          },
          {
            provider = function(self)
              local count = self.status_dict.changed or 0
              return count > 0 and ("~" .. count)
            end,
            hl = { fg = "git_change" },
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
          hl = { fg = "diag_" .. type },
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

        update = { "DiagnosticChanged", "BufEnter" },

        hl = { bg = "bg" },

        diagnostic_provider "error",
        diagnostic_provider "warning",
        diagnostic_provider "info",
        diagnostic_provider "hint",
      }

      local Lsp = {
        condition = conditions.lsp_attached,
        update = { "LspAttach", "LspDetach" },

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
        hl = { bg = "bg", fg = "special" },
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
            local vcount = math.abs(end_line - start_line) + 1
            return string.format(" [sel %2d]", vcount)
          end,
          hl = function(_)
            return { fg = in_visual_mode() and "blue" or "fg" }
          end,
        },
      }

      local Left = {
        Mode,
        FileBlock,
        Git,
      }

      local Right = {
        Pad(Diagnostics, 1),
        Lsp,
        Space(1),
        Ruler,
      }

      local statusline = { Left, Align, Right }

      require("heirline").setup {
        statusline = statusline,
        opts = { colors = setup_colors },
      }

      vim.api.nvim_create_augroup("Heirline", { clear = true })
      vim.api.nvim_create_autocmd({ "ColorScheme", "BufWinEnter" }, {
        callback = function()
          utils.on_colorscheme(setup_colors)
        end,
        group = "Heirline",
      })
    end,
  },
}
