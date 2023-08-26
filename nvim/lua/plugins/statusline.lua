return {
  "rebelot/heirline.nvim",
  config = function()
    local conditions = require "heirline.conditions"
    local utils = require "heirline.utils"
    local heirline = require "heirline"

    local function setup_colors()
      return {
        bright_bg = utils.get_highlight("Folded").bg,
        bright_fg = utils.get_highlight("Folded").fg,
        red = utils.get_highlight("DiagnosticError").fg,
        dark_red = utils.get_highlight("DiffDelete").bg,
        green = utils.get_highlight("String").fg,
        blue = utils.get_highlight("Function").fg,
        gray = utils.get_highlight("NonText").fg,
        orange = utils.get_highlight("Constant").fg,
        purple = utils.get_highlight("Statement").fg,
        cyan = utils.get_highlight("Special").fg,
        diag_warn = utils.get_highlight("DiagnosticWarn").fg,
        diag_error = utils.get_highlight("DiagnosticError").fg,
        diag_hint = utils.get_highlight("DiagnosticHint").fg,
        diag_info = utils.get_highlight("DiagnosticInfo").fg,
        git_del = utils.get_highlight("diffDeleted").fg,
        git_add = utils.get_highlight("diffAdded").fg,
        git_change = utils.get_highlight("diffChanged").fg,
      }
    end

    heirline.setup {}

    heirline.load_colors(setup_colors)

    vim.api.nvim_create_augroup("Heirline", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        utils.on_colorscheme(setup_colors)
      end,
      group = "Heirline",
    })
  end,
}
-- return {
--   {
--     "nvim-lualine/lualine.nvim",
--     dependencies = {
--       "arkav/lualine-lsp-progress",
--     },
--     config = function()
--       local utils = require "utils"
--
--       require("lualine").setup {
--         options = {
--           icons_enabled = true,
--           theme = "auto",
--           globalstatus = true,
--           disabled_filetypes = { statusline = { "dashboard", "alpha" } },
--           component_separators = "|",
--           section_separators = "",
--         },
--         sections = {
--           lualine_a = { "mode" },
--           lualine_b = { "branch" },
--           lualine_c = {
--             {
--               "filename",
--               file_status = true,
--               path = 1,
--             },
--             "lsp_progress",
--           },
--           lualine_x = {
--             {
--               "diagnostics",
--               sources = { "nvim_diagnostic" },
--               symbols = {
--                 error = utils.icons.error .. " ",
--                 warn = utils.icons.warning .. " ",
--                 info = utils.icons.info .. " ",
--                 hint = utils.icons.bulb .. " ",
--               },
--             },
--             {
--               require("lazy.status").updates,
--               cond = require("lazy.status").has_updates,
--             },
--             "encoding",
--             "filetype",
--           },
--           lualine_y = {
--             {
--               "progress",
--               separator = " ",
--               padding = { left = 1, right = 0 },
--             },
--             {
--               "location",
--               padding = { left = 0, right = 1 },
--             },
--           },
--           lualine_z = {
--             function()
--               return utils.icons.clock .. " " .. os.date "%R"
--             end,
--           },
--         },
--         extensions = { "fugitive", "neo-tree", "lazy" },
--       }
--     end,
--   },
-- }
