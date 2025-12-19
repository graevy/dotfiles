return {
  name = "rust_analyzer",
  cmd = { "rust-analyzer" },
  filetypes = { "rs", "rust" },
  root_markers = {
    "Cargo.toml",
    "rust-project.json",
    ".git",
  },
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
      },
      checkOnSave = {
        command = "clippy",
      },
      diagnostics = {
        enable = true,
        experimental = {
          enable = true,
        },
      },
      completion = {
        postfix = {
          enable = true,
        },
      },
      inlayHints = {
        lifetimeElisionHints = {
          enable = true,
          useParameterNames = true,
        },
        bindingModeHints = {
          enable = true,
        },
        chainingHints = {
          enable = true,
        },
        typeHints = {
          enable = true,
        },
        parameterHints = {
          enable = true,
        },
      },
      lens = {
        enable = true,
      },
    },
  },
}
