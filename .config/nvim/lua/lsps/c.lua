local lsp = vim.lsp

local capabilities = vim.tbl_deep_extend(
  "force",
  {},
  lsp.protocol.make_client_capabilities()
)

lsp.config("clangd", {
  cmd = { "clangd" },
  filetypes = {
    "c",
    "cpp",
    "objc",
    "objcpp",
    "cuda",
    "proto",
  },
  root_markers = {
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac",
    ".git",
  },
  capabilities = capabilities,
})

return {
  name = "clangd",
  filetypes = {
    "c",
    "cpp",
    "objc",
    "objcpp",
    "cuda",
    "proto",
  },
}

