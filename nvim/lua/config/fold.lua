vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.opt.foldcolumn = "1"
vim.opt.foldminlines = 1
vim.opt.foldnestmax = 3
vim.opt.fillchars:append({
  fold = "󰧟",
  foldopen = "",
  foldclose = "",
})

-- vim.o.foldmethod = "expr"
-- vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.opt.foldtext = "v:lua.custom_foldtext()"

-- -- Custom foldtext
-- local function fold_virt_text(result, s, lnum, coloff)
--   if not coloff then
--     coloff = 0
--   end
--   local text = ""
--   local hl
--   for i = 1, #s do
--     local char = s:sub(i, i)
--     local hls = vim.treesitter.get_captures_at_pos(0, lnum, coloff + i - 1)
--     local _hl = hls[#hls]
--     if _hl then
--       local new_hl = "@" .. _hl.capture
--       if new_hl ~= hl then
--         table.insert(result, { text, hl })
--         text = ""
--         hl = nil
--       end
--       text = text .. char
--       hl = new_hl
--     else
--       text = text .. char
--     end
--   end
--   table.insert(result, { text, hl })
-- end

-- function _G.custom_foldtext()
--   local start = vim.fn.getline(vim.v.foldstart):gsub("\t", string.rep(" ", vim.o.tabstop))
--   local end_str = vim.fn.getline(vim.v.foldend)
--   local end_ = vim.trim(end_str)
--   local result = {}
--   fold_virt_text(result, start, vim.v.foldstart - 1)
--   table.insert(result, { " ... ", "Delimiter" })
--   fold_virt_text(result, end_, vim.v.foldend - 1, #(end_str:match("^(%s+)") or ""))
--   table.insert(result, { " ", "Comment" })
--   return result
-- end
