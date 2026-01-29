return {
  settings = {
    ["rust-analyzer"] = {
      imports = {
        granularity = {
          group = "crate",
        },
        prefix = "self",
      },
      assist = {
        importEnforceGranularity = true,
        importPrefix = "crate",
        emitMustUse = true,
      },
      cargo = {
        features = "all",
        allFeatures = true,
        buildScripts = {
          enable = true,
        },
      },
      check = {
        command = "clippy",
      },
      checkOnSave = true,
      inlayHints = {
        enable = false,
        locationLinks = false,
      },
      diagnostics = {
        enable = true,
        experimental = {
          enable = true,
        },
        disabled = { "inactive-code" },
      },
      procMacro = {
        enable = true,
      },
      semanticHighlighting = {
        operator = { specialization = { enable = true } },
        punctuation = {
          enable = true,
          specialization = { enable = true },
          separate = { macro = { bang = true } },
        },
      },
    },
  },
  -- TODO: get Rust debugging to work
  -- dap = {
  --   adapter = {
  --     type = "server",
  --     port = "${port}",
  --     host = "127.0.0.1",
  --     executable = {
  --       command = codelldb_path,
  --       args = { "--liblldb", liblldb_path, "--port", "${port}" },
  --     },
  --   },
  -- },
}
