return {
  {
    "rebelot/heirline.nvim",
    dependencies = { "rebelot/kanagawa.nvim" },
    config = function()
      local conditions = require "heirline.conditions"
      local utils = require "heirline.utils"

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
          diag_warn = colors.theme.diag.warning,
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
            niI = "NOR/i",
            niR = "NOR/r",
            niV = "NOR/v",
            nt = "NOR/t",
            v = "VIS",
            vs = "VIS",
            V = "VIS/l",
            Vs = "VIS",
            ["\22"] = "VIS/b",
            ["\22s"] = "VIS/b",
            s = "SEL",
            S = "SEL",
            ["\19"] = "SEL/b",
            i = "INS",
            ic = "INS/c",
            ix = "INS/x",
            R = "REP",
            Rc = "REP/c",
            Rx = "REP/x",
            Rv = "REP/v",
            Rvc = "REP/vc",
            Rvx = "REP/vx",
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
          return " %4(" .. self.mode_names[self.mode] .. "%)  "
        end,
        hl = function(self)
          local mode = self.mode:sub(1, 1) -- get only the first mode character
          return { bg = "bg", fg = self.mode_colors[mode], bold = false }
        end,
        -- update = {
        --   "ModeChanged",
        --   pattern = "*:*",
        --   callback = vim.schedule_wrap(function()
        --     vim.cmd "redrawstatus"
        --   end),
        -- },
      }

      local FileNameBlock = {
        init = function(self)
          self.filename = vim.api.nvim_buf_get_name(0)
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
          if not conditions.width_percent_below(#filename, 0.25) then
            filename = vim.fn.pathshorten(filename)
          end
          return filename
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

      local FileNameModifer = {
        hl = function()
          if vim.bo.modified then
            return { fg = "fg", bold = true, force = true }
          end
        end,
      }

      FileNameBlock =
        utils.insert(FileNameBlock, FileIcon, utils.insert(FileNameModifer, FileName), FileFlags, { provider = "%<" })

      local Git = {
        condition = conditions.is_git_repo,

        init = function(self)
          self.status_dict = vim.b.gitsigns_status_dict
          self.has_changes = self.status_dict.added ~= 0
            or self.status_dict.removed ~= 0
            or self.status_dict.changed ~= 0
        end,

        hl = { fg = "special" },

        {
          provider = function(self)
            return " " .. self.status_dict.head
          end,
          hl = { bold = true },
        },

        {
          condition = function(self)
            return self.has_changes
          end,
          provider = "(",
        },
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
        {
          condition = function(self)
            return self.has_changes
          end,
          provider = ")",
        },
      }

      local icons = require("config.utils").icons
      local Diagnostics = {
        condition = conditions.has_diagnostics,

        init = function(self)
          self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
          self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
          self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
          self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
        end,

        update = { "DiagnosticChanged", "BufEnter" },

        hl = { bg = "bg" },

        {
          provider = function(self)
            -- 0 is just another output, we can decide to print it or not!
            return self.errors > 0 and (icons.error .. self.errors .. " ")
          end,
          hl = { fg = "diag_error" },
        },
        {
          provider = function(self)
            return self.warnings > 0 and (icons.warning .. self.warnings .. " ")
          end,
          hl = { fg = "diag_warn" },
        },
        {
          provider = function(self)
            return self.info > 0 and (icons.info .. self.info .. " ")
          end,
          hl = { fg = "diag_info" },
        },
        {
          provider = function(self)
            return self.hints > 0 and (icons.hint .. self.hints)
          end,
          hl = { fg = "diag_hint" },
        },
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

      local Ruler = { provider = "%l:%c %P" }

      local Time = {
        provider = function()
          return " " .. os.date "%H:%M"
        end,
      }

      local Left = {
        Mode,
        FileNameBlock,
        Pad(Git, 2),
      }

      local Right = {
        Pad(Diagnostics, 1),
        Lsp,
        Space(2),
        Ruler,
        Pad(Time, 2),
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
