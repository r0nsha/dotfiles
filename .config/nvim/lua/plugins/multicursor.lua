local mc = require("multicursor-nvim")
mc.setup()

---@param desc string
local function opts(desc)
  return {
    desc = "Multicursor: " .. desc,
  }
end

-- Add or skip cursor above/below the main cursor.
vim.keymap.set({ "n", "x" }, "<Up>", function() mc.lineAddCursor(-1) end, opts("Add cursor above"))
vim.keymap.set({ "n", "x" }, "<Down>", function() mc.lineAddCursor(1) end, opts("Add cursor below"))

-- Add a new cursor by matching word/selection
vim.keymap.set(
  { "n", "x" },
  "<C-S-N>",
  function() mc.matchAddCursor(-1) end,
  opts("Add cursor match above")
)
vim.keymap.set(
  { "n", "x" },
  "<C-n>",
  function() mc.matchAddCursor(1) end,
  opts("Add cursor match below")
)

-- Easy way to add and remove cursors using the main cursor.
vim.keymap.set("n", "m.", mc.toggleCursor, opts("Toggle cursor"))

-- Add all matches in the document
vim.keymap.set("n", "mm", function()
  if vim.v.hlsearch == 1 then
    local count = vim.fn.searchcount({ recompute = 1 })
    if count and count.total > 0 then
      mc.searchAllAddCursors()
      return
    end
  end

  mc.matchAllAddCursors()
end, opts("Add cursors to all matches"))

-- Match new cursors within visual selections by regex.
vim.keymap.set("x", "mm", mc.matchCursors, opts("Match cursors by regex"))

-- Split visual selections by regex.
vim.keymap.set("x", "M", mc.splitCursors, opts("Split cursors by regex"))

-- Bring back cursors if you accidentally clear them
vim.keymap.set("n", "mR", mc.restoreCursors, opts("Restore cursors"))

-- Append/insert for each line of visual selections.
vim.keymap.set("x", "I", mc.insertVisual, opts("Insert"))
vim.keymap.set("x", "A", mc.appendVisual, opts("Append"))

-- Jumplist support
vim.keymap.set({ "n", "x" }, "<C-i>", mc.jumpForward, opts("Jump forward"))
vim.keymap.set({ "n", "x" }, "<C-o>", mc.jumpBackward, opts("Jump backward"))

mc.addKeymapLayer(function(layerSet)
  layerSet(
    { "n", "x" },
    "<C-Up>",
    function() mc.lineSkipCursor(-1) end,
    { desc = "Skip cursor above" }
  )
  layerSet(
    { "n", "x" },
    "<C-Down>",
    function() mc.lineSkipCursor(1) end,
    { desc = "Skip cursor below" }
  )

  layerSet(
    { "n", "x" },
    "<C-S-Q>",
    function() mc.matchSkipCursor(-1) end,
    { desc = "Skip cursor match above" }
  )
  layerSet(
    { "n", "x" },
    "<C-q>",
    function() mc.matchSkipCursor(1) end,
    { desc = "Skip cursor match below" }
  )

  -- Rotate the main cursor.
  layerSet({ "n", "x" }, "<Left>", mc.prevCursor, { desc = "Rotate cursor left" })
  layerSet({ "n", "x" }, "<Right>", mc.nextCursor, { desc = "Rotate cursor right" })

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
