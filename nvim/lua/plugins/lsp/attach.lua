local utils = require("utils")

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(event)
    local buf = event.buf
    local id = vim.tbl_get(event, "data", "client_id")
    local client = id and vim.lsp.get_client_by_id(id)

    if client == nil then
      return
    end

    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = buf })
    end

    local opts = function(desc)
      return {
        buffer = buf,
        desc = "LSP: " .. desc,
      }
    end

    -- keymaps

    ---@type snacks.picker.Config
    local picker_opts = {
      layout = require("plugins.snacks.picker").ivy_cursor,
    }

    vim.keymap.set("n", "gd", function()
      vim.api.nvim_feedkeys("zz", "n", true)
      Snacks.picker.lsp_definitions(picker_opts)
    end, opts("Go to Definition"))

    vim.keymap.set("n", "gv", "<C-w>v<C-]>", opts("Go to Definition (VSplit)"))

    vim.keymap.set("n", "grd", function()
      vim.api.nvim_feedkeys("zz", "n", true)
      Snacks.picker.lsp_declarations(picker_opts)
    end, opts("Declarations"))

    vim.keymap.set("n", "grr", function()
      vim.api.nvim_feedkeys("zz", "n", true)
      Snacks.picker.lsp_references(picker_opts)
    end, opts("References"))

    vim.keymap.set("n", "gt", function()
      vim.api.nvim_feedkeys("zz", "n", true)
      Snacks.picker.lsp_type_definitions(picker_opts)
    end, opts("Type Definitions"))

    vim.keymap.set("n", "grt", function()
      vim.api.nvim_feedkeys("zz", "n", true)
      Snacks.picker.lsp_type_definitions(picker_opts)
    end, opts("Type Definitions"))

    vim.keymap.set("n", "gri", function()
      vim.api.nvim_feedkeys("zz", "n", true)
      Snacks.picker.lsp_implementations(picker_opts)
    end, opts("Implementations"))

    vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts("Rename"))
    vim.keymap.set({ "n", "v" }, "gra", require("actions-preview").code_actions, opts("Code Action"))
    vim.keymap.set({ "n", "v" }, "ga", require("actions-preview").code_actions, opts("Code Action"))
    -- vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts "Signature Help")
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Hover"))
    vim.keymap.set("n", "gh", function()
      local enable = not vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
      vim.lsp.inlay_hint.enable(enable, { bufnr = buf })
      vim.notify("Inlay hints " .. utils.bool_to_enabled(enable))
    end, opts("Toggle Inlay Hints"))

    vim.keymap.set("n", "[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, opts("Previous Diagnostic"))
    vim.keymap.set("n", "]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, opts("Next Diagnostic"))
  end,
})
