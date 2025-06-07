return {
  "jake-stewart/multicursor.nvim",
  config = function()
    local mc = require "multicursor-nvim"
    mc.setup()

    local function opts(desc)
      return {
        desc = "Multicursor: " .. desc,
      }
    end

    -- Add or skip cursor above/below the main cursor.
    vim.keymap.set({ "n", "x" }, "<c-up>", function()
      mc.lineAddCursor(-1)
    end, opts "Add Cursor Above")
    vim.keymap.set({ "n", "x" }, "<c-s-up>", function()
      mc.lineSkipCursor(-1)
    end, opts "Skip Cursor Above")
    vim.keymap.set({ "n", "x" }, "<c-down>", function()
      mc.lineAddCursor(1)
    end, opts "Add Cursor Below")
    vim.keymap.set({ "n", "x" }, "<c-s-down>", function()
      mc.lineSkipCursor(1)
    end, opts "Skip Cursor Below")

    -- Add a new cursor by matching word/selection
    vim.keymap.set({ "n", "x" }, "<c-N>", function()
      mc.matchAddCursor(-1)
    end, opts "Add Cursor Match Above")
    vim.keymap.set({ "n", "x" }, "<c-n>", function()
      mc.matchAddCursor(1)
    end, opts "Add Cursor Match Below")

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
    vim.keymap.set("n", "mw", mc.operator, opts "Operator")

    -- Add all matches in the document
    vim.keymap.set("n", "mm", mc.matchAllAddCursors, opts "Add Cursors to All Matches")

    -- Match new cursors within visual selections by regex.
    vim.keymap.set("x", "mm", mc.matchCursors, opts "Match Cursors by Regex")

    mc.addKeymapLayer(function(layerSet)
      layerSet({ "n", "x" }, "<c-Q>", function()
        mc.matchSkipCursor(-1)
      end, opts "Skip Cursor Match Above")
      layerSet({ "n", "x" }, "<c-q>", function()
        mc.matchSkipCursor(1)
      end, opts "Skip Cursor Match Below")

      -- Rotate the main cursor.
      layerSet({ "n", "x" }, "<left>", mc.prevCursor, opts "Rotate Cursor Left")
      layerSet({ "n", "x" }, "<right>", mc.nextCursor, opts "Rotate Cursor Right")

      -- Delete the main cursor.
      layerSet({ "n", "x" }, "mx", mc.deleteCursor, opts "Delete Cursor")

      -- Easy way to add and remove cursors using the main cursor.
      layerSet({ "n", "x" }, "mt", mc.toggleCursor, opts "Toggle Cursor")

      -- Clone every cursor and disable the originals.
      layerSet({ "n", "x" }, "md", mc.duplicateCursors, opts "Duplicate Cursors")

      layerSet("n", "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        elseif mc.hasCursors() then
          mc.clearCursors()
        else
          -- Default <esc> handler.
        end
      end)

      -- Align cursor columns.
      layerSet("n", "ma", mc.alignCursors, opts "Align Cursors")

      -- Bring back cursors if you accidentally clear them
      layerSet("n", "mr", mc.restoreCursors, opts "Restore Cursors")
    end)

    -- Split visual selections by regex.
    vim.keymap.set("x", "ms", mc.splitCursors, opts "Split Cursors by Regex")

    -- Append/insert for each line of visual selections.
    vim.keymap.set("x", "I", mc.insertVisual, opts "Insert")
    vim.keymap.set("x", "A", mc.appendVisual, opts "Append")

    -- Rotate visual selection contents.
    -- vim.keymap.set("x", "mt", function()
    --   mc.transposeCursors(1)
    -- end, opts "Transpose Cursors")
    -- vim.keymap.set("x", "mT", function()
    --   mc.transposeCursors(-1)
    -- end, opts "Transpose Cursors (Reverse)")

    -- Jumplist support
    vim.keymap.set({ "x", "n" }, "<c-i>", mc.jumpForward, opts "Jump Forward")
    vim.keymap.set({ "x", "n" }, "<c-o>", mc.jumpBackward, opts "Jump Backward")

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
}
