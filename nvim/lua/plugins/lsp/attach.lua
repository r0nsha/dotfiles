local utils = require "utils"

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(args)
    local buf = args.buf
    local id = vim.tbl_get(args, "data", "client_id")
    local client = id and vim.lsp.get_client_by_id(id)

    if client == nil then
      return
    end

    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(false, { bufnr = buf })
    end

    local opts = function(desc)
      return {
        buffer = buf,
        desc = "LSP: " .. desc,
      }
    end

    vim.keymap.set("n", "gd", Snacks.picker.lsp_definitions, opts "Go to Definition")
    vim.keymap.set("n", "grd", Snacks.picker.lsp_declarations, opts "Declarations")
    vim.keymap.set("n", "grr", Snacks.picker.lsp_references, opts "References")
    vim.keymap.set("n", "grt", Snacks.picker.lsp_type_definitions, opts "Type Definitions")
    vim.keymap.set("n", "gri", Snacks.picker.lsp_implementations, opts "Implementations")

    vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts "Rename")
    vim.keymap.set({ "n", "x" }, "gra", vim.lsp.buf.code_action, opts "Code Action")
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts "Hover")
    vim.keymap.set("n", "grh", function()
      local enable = not vim.lsp.inlay_hint.is_enabled { bufnr = buf }
      vim.lsp.inlay_hint.enable(enable, { bufnr = buf })
      vim.notify("Inlay hints " .. utils.bool_to_enabled(enable))
    end, opts "Toggle Inlay Hints")

    vim.keymap.set({ "n", "x" }, "[d", function()
      vim.diagnostic.jump { count = -1, float = true }
    end, opts "Previous Diagnostic")
    vim.keymap.set({ "n", "x" }, "]d", function()
      vim.diagnostic.jump { count = 1, float = true }
    end, opts "Next Diagnostic")

    vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts "Signature Help")

    vim.keymap.set("n", "<leader>x", vim.diagnostic.setqflist, opts "Diagnostics")
  end,
})

do
  local method_name = "textDocument/publishDiagnostics"
  local default_handler = vim.lsp.handlers[method_name]
  vim.lsp.handlers[method_name] = function(err, method, result, client_id)
    default_handler(err, method, result, client_id)
    vim.diagnostic.setloclist { open = false }
  end
end
