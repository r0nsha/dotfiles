local group = vim.api.nvim_create_augroup("CustomBlameNvim", { clear = true })

return {
  {
    "FabijanZulj/blame.nvim",
    event = "VeryLazy",
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("blame").setup {
        virtual_style = "right_align",
        blame_options = { "-w" },
        merge_consecutive = true,
        commit_detail_view = "tab",
        mappings = {
          commit_info = "i",
          stack_push = { "<C-n>", "<Tab>" },
          stack_pop = { "<C-p>", "<S-Tab>" },
          show_commit = { "<C-y>", "<CR>" },
          close = "q",
        },
      }

      local opened = {
        window = false,
        virtual = false,
      }

      ---@param type "window" | "virtual"
      local function toggle_blame(type)
        vim.cmd("BlameToggle " .. type)
      end

      ---@param type "window" | "virtual"
      local function toggle_blame_exclusive(type)
        return function()
          -- If the requested type is already open, close it
          if opened[type] then
            toggle_blame(type)
            opened[type] = false
            return
          end

          -- Otherwise, close any other open blame type first
          for blame_type, is_open in pairs(opened) do
            if is_open and blame_type ~= type then
              toggle_blame(type)
              opened[blame_type] = false
            end
          end

          -- Then, open the requested type
          toggle_blame(type)
          opened[type] = true
        end
      end

      vim.keymap.set("n", "<leader>gb", toggle_blame_exclusive "window", { desc = "Git: Blame" })
      vim.keymap.set("n", "<leader>gB", toggle_blame_exclusive "virtual", { desc = "Git: Blame" })

      vim.api.nvim_create_autocmd({ "FileType" }, {
        group = group,
        pattern = "blame",
        callback = function(args)
          vim.keymap.set("n", "d", function()
            local lnum = vim.fn.line "."
            local last_lnum = vim.api.nvim_buf_line_count(0)

            while lnum <= last_lnum do
              local line_content = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1]

              if vim.trim(line_content) ~= "" then
                ---@type string?
                local hash = line_content:match "^(%x+)%s%s"
                if hash then
                  vim.cmd("DiffviewOpen " .. hash)
                end
                break
              end

              lnum = lnum + 1
            end
          end, { desc = "Show diff", buffer = args.buf })
        end,
      })
    end,
  },
}
