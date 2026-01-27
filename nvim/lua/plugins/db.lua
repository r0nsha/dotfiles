-- TODO: remove?
-- require("utils.pack").add_with_build("https://github.com/kndndrj/nvim-dbee", function() require("dbee").install() end)
--
-- local sources = require("dbee.sources")
--
-- require("dbee").setup({
--   sources = {
--     sources.MemorySource:new({
--       {
--         id = "non-prod.eu-west-1.staging.data-domain-1",
--         name = "non-prod | eu-west-1 | staging | data-domain-1",
--         type = "postgres",
--         url = "postgres://twingate-connector-read-only:{{ exec `rds-token --hostname eu-west-1-staging-data-domain-1.cez8gmmvztw6.eu-west-1.rds.amazonaws.com --port 5432 --username twingate-connector-read-only --region eu-west-1 --profile non-prod` }}@rds.data-domain-1.non-prod.eu-west-1.staging:5432/data_domain_stack_1",
--       },
--     }),
--   },
-- })

vim.keymap.set("n", "<leader>D", "<cmd>DBUIToggle<cr>", { desc = "Toggle DB" })

local data_path = vim.fn.stdpath("data")
vim.g.db_ui_auto_execute_table_helpers = 1
vim.g.db_ui_save_location = data_path .. "/dadbod_ui"
vim.g.db_ui_show_database_icon = true
vim.g.db_ui_tmp_query_location = data_path .. "/dadbod_ui/tmp"
vim.g.db_ui_use_nerd_fonts = true
vim.g.db_ui_use_nvim_notify = true

-- NOTE: The default behavior of auto-execution of queries on save is disabled
-- this is useful when you have a big query that you don't want to run every time
-- you save the file running those queries can crash neovim to run use the
-- default keymap: <leader>S
vim.g.db_ui_execute_on_save = false
