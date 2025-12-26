return {
  "jake-stewart/multicursor.nvim",
  config = function()
    local mc = require "multicursor-nvim"
    mc.setup()

    ---@param desc string
    local function opts(desc)
      ---@module "lazy"
      ---@type LazySpec
      return {
        desc = "Multicursor: " .. desc,
      }
    end

    -- Add or skip cursor above/below the main cursor.
    vim.keymap.set({ "n", "x" }, "<Up>", function()
      mc.lineAddCursor(-1)
    end, opts "Add Cursor Above")
    vim.keymap.set({ "n", "x" }, "<Down>", function()
      mc.lineAddCursor(1)
    end, opts "Add Cursor Below")

    -- Add a new cursor by matching word/selection
    vim.keymap.set({ "n", "x" }, "<C-S-N>", function()
      mc.matchAddCursor(-1)
    end, opts "Add Cursor Match Above")
    vim.keymap.set({ "n", "x" }, "<C-n>", function()
      mc.matchAddCursor(1)
    end, opts "Add Cursor Match Below")

    -- Easy way to add and remove cursors using the main cursor.
    vim.keymap.set("n", "<C-m>", mc.toggleCursor, opts "Toggle Cursor")

    -- Add all matches in the document
    vim.keymap.set("n", "<C-S-M>", mc.matchAllAddCursors, opts "Add Cursors to All Matches")

    -- Match new cursors within visual selections by regex.
    vim.keymap.set("x", "m", mc.matchCursors, opts "Match Cursors by Regex")

    -- Split visual selections by regex.
    vim.keymap.set("x", "M", mc.splitCursors, opts "Split Cursors by Regex")

    -- Bring back cursors if you accidentally clear them
    vim.keymap.set("n", "gM", mc.restoreCursors, opts "Restore Cursors")

    -- Append/insert for each line of visual selections.
    vim.keymap.set("x", "I", mc.insertVisual, opts "Insert")
    vim.keymap.set("x", "A", mc.appendVisual, opts "Append")

    -- Jumplist support
    vim.keymap.set({ "n", "x" }, "<C-i>", mc.jumpForward, opts "Jump Forward")
    vim.keymap.set({ "n", "x" }, "<C-o>", mc.jumpBackward, opts "Jump Backward")

    mc.addKeymapLayer(function(layerSet)
      layerSet({ "n", "x" }, "<C-Up>", function()
        mc.lineSkipCursor(-1)
      end, { desc = "Skip Cursor Above" })
      layerSet({ "n", "x" }, "<C-Down>", function()
        mc.lineSkipCursor(1)
      end, { desc = "Skip Cursor Below" })

      layerSet({ "n", "x" }, "<C-S-Q>", function()
        mc.matchSkipCursor(-1)
      end, { desc = "Skip Cursor Match Above" })
      layerSet({ "n", "x" }, "<C-q>", function()
        mc.matchSkipCursor(1)
      end, { desc = "Skip Cursor Match Below" })

      -- Rotate the main cursor.
      layerSet({ "n", "x" }, "<Left>", mc.prevCursor, { desc = "Rotate Cursor Left" })
      layerSet({ "n", "x" }, "<Right>", mc.nextCursor, { desc = "Rotate Cursor Right" })

      layerSet("n", "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        elseif mc.hasCursors() then
          mc.clearCursors()
        else
          -- Default <esc> handler.
        end
      end)
    end)
  end,
}
