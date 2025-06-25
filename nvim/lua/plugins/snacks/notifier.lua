local icons = require("utils").icons

return {
  "folke/snacks.nvim",
  opts = {
    notifier = {
      width = { min = 40, max = 0.3 },
      height = { min = 1, max = 0.4 },
      margin = { top = 0, right = 0, bottom = 1 },
      padding = false,
      icons = {
        error = icons.error,
        warn = icons.warning,
        info = icons.info,
        debug = icons.bug,
        trace = icons.trace,
      },
      style = function(buf, notif, ctx)
        ctx.opts.border = "none"
        local whl = ctx.opts.wo.winhighlight
        ctx.opts.wo.winhighlight = whl:gsub(ctx.hl.msg, "SnacksNotifierMinimal")
        ctx.opts.wo.wrap = true
        ctx.opts.wo.winblend = 0
        local lines = vim.tbl_map(function(l)
          return string.format(" %s  ", l)
        end, vim.split(notif.msg, "\n"))
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.api.nvim_buf_set_extmark(buf, ctx.ns, 0, 0, {
          virt_text = { { " " .. notif.icon .. " ", ctx.hl.icon } },
          virt_text_pos = "right_align",
        })
      end,
      top_down = false,
    },
  },
}
