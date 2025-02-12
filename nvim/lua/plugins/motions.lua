return {
  {
    "Wansmer/treesj",
    keys = {
      {
        "<leader>j",
        function()
          require("treesj").toggle()
        end,
        desc = "Toggle Split/Join",
      },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup {
        use_default_keymaps = false,
        max_join_length = 9000,
      }
    end,
  },
  {
    "jake-stewart/multicursor.nvim",
    config = function()
      local mc = require "multicursor-nvim"

      mc.setup()

      -- Add or skip cursor above/below the main cursor.
      vim.keymap.set({ "n", "x" }, "<up>", function()
        mc.lineAddCursor(-1)
      end)
      vim.keymap.set({ "n", "x" }, "<c-up>", function()
        mc.lineSkipCursor(-1)
      end)
      vim.keymap.set({ "n", "x" }, "<down>", function()
        mc.lineAddCursor(1)
      end)
      vim.keymap.set({ "n", "x" }, "<c-down>", function()
        mc.lineSkipCursor(1)
      end)

      -- Add or skip adding a new cursor by matching word/selection
      vim.keymap.set({ "n", "x" }, "<c-N>", function()
        mc.matchAddCursor(-1)
      end)
      vim.keymap.set({ "n", "x" }, "<c-n>", function()
        mc.matchAddCursor(1)
      end)
      vim.keymap.set({ "n", "x" }, "<c-M>", function()
        mc.matchSkipCursor(-1)
      end)
      vim.keymap.set({ "n", "x" }, "<c-m>", function()
        mc.matchSkipCursor(1)
      end)

      -- -- In normal/visual mode, press `mwap` will create a cursor in every match of
      -- -- the word captured by `iw` (or visually selected range) inside the bigger
      -- -- range specified by `ap`. Useful to replace a word inside a function, e.g. mwif.
      -- vim.keymap.set({ "n", "x" }, "mw", function()
      --   mc.operator { motion = "iw", visual = true }
      --   -- Or you can pass a pattern, press `mwi{` will select every \w,
      --   -- basically every char in a `{ a, b, c, d }`.
      --   -- mc.operator({ pattern = [[\<\w]] })
      -- end)

      -- Press `mWi"ap` will create a cursor in every match of string captured by `i"` inside range `ap`.
      vim.keymap.set("n", "mw", mc.operator)

      -- Add all matches in the document
      vim.keymap.set("n", "mm", mc.matchAllAddCursors)

      -- Match new cursors within visual selections by regex.
      vim.keymap.set("x", "mm", mc.matchCursors)

      -- Rotate the main cursor.
      vim.keymap.set({ "n", "x" }, "<left>", mc.prevCursor)
      vim.keymap.set({ "n", "x" }, "<right>", mc.nextCursor)

      -- Delete the main cursor.
      vim.keymap.set({ "n", "x" }, "mx", mc.deleteCursor)

      -- Easy way to add and remove cursors using the main cursor.
      vim.keymap.set({ "n", "x" }, "mq", mc.toggleCursor)

      -- Clone every cursor and disable the originals.
      vim.keymap.set({ "n", "x" }, "mD", mc.duplicateCursors)

      vim.keymap.set("n", "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        elseif mc.hasCursors() then
          mc.clearCursors()
        else
          -- Default <esc> handler.
        end
      end)

      -- bring back cursors if you accidentally clear them
      vim.keymap.set("n", "mr", mc.restoreCursors)

      -- Align cursor columns.
      vim.keymap.set("n", "ma", mc.alignCursors)

      -- Split visual selections by regex.
      vim.keymap.set("x", "ms", mc.splitCursors)

      -- Append/insert for each line of visual selections.
      vim.keymap.set("x", "I", mc.insertVisual)
      vim.keymap.set("x", "A", mc.appendVisual)

      -- Rotate visual selection contents.
      vim.keymap.set("x", "mt", function()
        mc.transposeCursors(1)
      end)
      vim.keymap.set("x", "mT", function()
        mc.transposeCursors(-1)
      end)

      -- Jumplist support
      vim.keymap.set({ "x", "n" }, "<c-i>", mc.jumpForward)
      vim.keymap.set({ "x", "n" }, "<c-o>", mc.jumpBackward)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { link = "Cursor" })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },
}
