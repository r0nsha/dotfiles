return {
  "rebelot/heirline.nvim",
  config = function()
    local conditions = require "heirline.conditions"
    local utils = require "heirline.utils"
    local heirline = require "heirline"

    local colors = require("kanagawa.colors").setup()

    heirline.setup {
      opts = {
        colors = colors,
      },
    }
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
