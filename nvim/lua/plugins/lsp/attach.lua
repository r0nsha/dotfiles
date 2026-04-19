local utils = require("utils")

vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(ev)
    local value = ev.data.params.value
    vim.api.nvim_echo({ { value.message or "done" } }, false, {
      id = "lsp." .. ev.data.params.token,
      kind = "progress",
      source = "vim.lsp",
      title = value.title,
      status = value.kind ~= "end" and "running" or "success",
      percent = value.percentage,
    })
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(args)
    local buf = args.buf
    local id = vim.tbl_get(args, "data", "client_id")
    local client = id and vim.lsp.get_client_by_id(id)

    if client == nil then return end

    vim.lsp.inlay_hint.enable(false, { bufnr = buf })
    vim.lsp.codelens.enable(false, { bufnr = buf })

    ---@param desc string
    local opts = function(desc) return { buffer = buf, desc = "LSP: " .. desc } end

    vim.keymap.set("n", "gd", Snacks.picker.lsp_definitions, opts("Go to Definition"))
    vim.keymap.set("n", "<c-w>gd", function()
      vim.cmd("vsplit")
      vim.lsp.buf.definition()
    end, opts("Go to Definition (split)"))
    vim.keymap.set("n", "grd", Snacks.picker.lsp_declarations, opts("Declarations"))
    vim.keymap.set("n", "grr", Snacks.picker.lsp_references, opts("References"))
    vim.keymap.set("n", "grt", Snacks.picker.lsp_type_definitions, opts("Type Definitions"))
    vim.keymap.set("n", "gri", Snacks.picker.lsp_implementations, opts("Implementations"))
    vim.keymap.set("n", "grs", Snacks.picker.lsp_workspace_symbols, opts("Workspace Symbols"))
    vim.keymap.set("n", "grS", Snacks.picker.lsp_symbols, opts("Symbols"))
    vim.keymap.set("n", "grq", vim.diagnostic.setqflist, opts("Diagnostics"))
    vim.keymap.set("n", "grQ", vim.diagnostic.setloclist, opts("Buffer Diagnostics"))
    vim.keymap.set("n", "gre", vim.diagnostic.open_float, opts("Show Diagnostic"))
    vim.keymap.set(
      "n",
      "grm",
      function()
        vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" }, diagnostics = {} }, apply = true })
      end,
      opts("Organize Imports")
    )
    vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts("Rename"))
    vim.keymap.set("n", "grA", vim.lsp.codelens.run, opts("Rename"))
    vim.keymap.set({ "n", "x" }, "gra", vim.lsp.buf.code_action, opts("Code Action"))
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Hover"))

    vim.keymap.set(
      { "n", "x" },
      "[d",
      function() vim.diagnostic.jump({ count = -1, float = true }) end,
      opts("Previous Diagnostic")
    )
    vim.keymap.set(
      { "n", "x" },
      "]d",
      function() vim.diagnostic.jump({ count = 1, float = true }) end,
      opts("Next Diagnostic")
    )

    vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts("Signature Help"))
  end,
})

do
  local method_name = "textDocument/publishDiagnostics"
  local default_handler = vim.lsp.handlers[method_name]
  vim.lsp.handlers[method_name] = function(err, method, result, client_id)
    default_handler(err, method, result, client_id)
    vim.diagnostic.setloclist({ open = false })
  end
end

vim.keymap.set("n", "grh", function()
  local enable = not vim.lsp.inlay_hint.is_enabled()
  vim.lsp.inlay_hint.enable(enable)
  vim.notify("Inlay hints " .. utils.bool_to_enabled(enable))
end, { desc = "LSP: Toggle Inlay Hints" })

vim.keymap.set("n", "grc", function()
  local enable = not vim.lsp.codelens.is_enabled()
  vim.lsp.codelens.enable(enable)
  vim.notify("CodeLens " .. utils.bool_to_enabled(enable))
end, { desc = "LSP: Toggle CodeLens" })
