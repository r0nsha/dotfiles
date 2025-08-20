return {
  "jake-stewart/multicursor.nvim",
  config = function()
    local mc = require("multicursor-nvim")
    mc.setup()

    ---@param desc string
    local function opts(desc)
      return {
        desc = "Multicursor: " .. desc,
      }
    end

    -- Add or skip cursor above/below the main cursor.
    vim.keymap.set({ "n", "x" }, "<M-c>", function()
      mc.lineAddCursor(-1)
    end, opts("Add Cursor Above"))
    vim.keymap.set({ "n", "x" }, "C", function()
      mc.lineAddCursor(1)
    end, opts("Add Cursor Below"))

    -- Add a new cursor by matching word/selection
    vim.keymap.set({ "n", "x" }, "<c-N>", function()
      mc.matchAddCursor(-1)
    end, opts("Add Cursor Match Above"))
    vim.keymap.set({ "n", "x" }, "<c-n>", function()
      mc.matchAddCursor(1)
    end, opts("Add Cursor Match Below"))

    -- -- Press `mWi"ap` will create a cursor in every match of string captured by `i"` inside range `ap`.
    vim.keymap.set("n", "mw", mc.operator, opts("Operator"))

    -- Add all matches in the document
    vim.keymap.set("n", "mm", mc.matchAllAddCursors, opts("Add Cursors to All Matches"))

    -- Match new cursors within visual selections by regex.
    vim.keymap.set("x", "mm", mc.matchCursors, opts("Match Cursors by Regex"))

    -- Easy way to add and remove cursors using the main cursor.
    vim.keymap.set({ "n", "x" }, "mt", mc.toggleCursor, opts("Toggle Cursor"))

    mc.addKeymapLayer(function(layerSet)
      layerSet({ "n", "x" }, "<M-Q>", function()
        mc.lineSkipCursor(-1)
      end, { desc = "Skip Cursor Above" })
      layerSet({ "n", "x" }, "<M-q>", function()
        mc.lineSkipCursor(1)
      end, { desc = "Skip Cursor Below" })

      layerSet({ "n", "x" }, "<c-Q>", function()
        mc.matchSkipCursor(-1)
      end, { desc = "Skip Cursor Match Above" })
      layerSet({ "n", "x" }, "<c-q>", function()
        mc.matchSkipCursor(1)
      end, { desc = "Skip Cursor Match Below" })

      -- Rotate the main cursor.
      layerSet({ "n", "x" }, "<left>", mc.prevCursor, { desc = "Rotate Cursor Left" })
      layerSet({ "n", "x" }, "<right>", mc.nextCursor, { desc = "Rotate Cursor Right" })

      -- Delete the main cursor.
      layerSet({ "n", "x" }, "mx", mc.deleteCursor, { desc = "Delete Cursor" })

      -- Clone every cursor and disable the originals.
      layerSet({ "n", "x" }, "md", mc.duplicateCursors, { desc = "Duplicate Cursors" })

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
      layerSet("n", "ma", mc.alignCursors, { desc = "Align Cursors" })

      -- Bring back cursors if you accidentally clear them
      layerSet("n", "mr", mc.restoreCursors, { desc = "Restore Cursors" })
    end)

    -- Split visual selections by regex.
    vim.keymap.set("x", "ms", mc.splitCursors, opts("Split Cursors by Regex"))

    -- Append/insert for each line of visual selections.
    vim.keymap.set("x", "I", mc.insertVisual, opts("Insert"))
    vim.keymap.set("x", "A", mc.appendVisual, opts("Append"))

    -- Jumplist support
    vim.keymap.set({ "x", "n" }, "<c-i>", mc.jumpForward, opts("Jump Forward"))
    vim.keymap.set({ "x", "n" }, "<c-o>", mc.jumpBackward, opts("Jump Backward"))
  end,
}
