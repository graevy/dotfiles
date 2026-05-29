local lsp = vim.lsp

local capabilities = vim.tbl_deep_extend(
  "force",
  {},
  lsp.protocol.make_client_capabilities()
)

lsp.config("pylsp", {
  cmd = { "pylsp" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    ".git",
  },
  capabilities = capabilities,
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = { "W391" },
          maxLineLength = 100,
        },
        pyflakes = { enabled = true },
        autopep8 = { enabled = true },
        yapf = { enabled = false },
        pylint = { enabled = false },
      },
    },
  },
})

return {
  name = "pylsp",
  filetypes = { "python" },
}

