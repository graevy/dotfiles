local lsp = vim.lsp

local capabilities = vim.tbl_deep_extend(
  "force",
  {},
  lsp.protocol.make_client_capabilities()
)

lsp.config("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
  capabilities = capabilities,
  settings = {
    gopls = {
      gofumpt = true,
      codelenses = {
        generate = true,
        test = true,
        tidy = true,
        vendor = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      analyses = {
        fieldalignment = true,
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      usePlaceholders = true,
      completeUnimported = true,
      staticcheck = true,
      directoryFilters = {
        "-.git",
        "-.vscode",
        "-.idea",
        "-node_modules",
      },
      semanticTokens = true,
    },
  },
})

return {
  name = "gopls",
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
}

