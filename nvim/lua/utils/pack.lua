local Pack = {}

--- Calls vim.pack.add, making sure that `build` is called after
--- the package is installed or updated.
---@param src string
---@param build function
function Pack.add_with_build(src, build)
  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      local _src, name, kind = ev.data.spec.src, ev.data.spec.name, ev.data.kind
      if src == _src and (kind == "install" or kind == "update") then
        if not ev.data.active then vim.cmd.packadd(name) end
        build()
      end
    end,
  })

  vim.pack.add({ { src = src } })
end

return Pack
