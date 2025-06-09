-- modular LSP config for neovim 0.11+ (it uses vim.lsp.config)
local M = {}

local lsp_setup_done = false

-- build LSP capabilities
local function build_capabilities()
  return vim.tbl_deep_extend(
    -- merge strategy - later values override earlier values
    "force",
    -- instantiate an empty table
    {},
    -- append default neovim client capabilities to the table
    -- https://github.com/neovim/neovim/blob/cb4559bc32049d2268ab002207bb7445027e9264/runtime/lua/vim/lsp/protocol.lua#L331
    vim.lsp.protocol.make_client_capabilities(),
    {
      -- overrides
      workspace = {
        fileOperations = {
          -- gives file rename information to the lsp to notify you if things break from a rename
          didRename = true,
          willRename = true,
        },
      },
    }
  )
end

-- diagnostics
local function setup_diagnostics()
  vim.diagnostic.config({
    underline = true,
    update_in_insert = false,
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "●",
    },
    severity_sort = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "E",
        [vim.diagnostic.severity.WARN] = "W",
        [vim.diagnostic.severity.HINT] = "H",
        [vim.diagnostic.severity.INFO] = "I",
      },
    },
  })
end

-- setup LSP servers using vim.lsp.config()
local function setup_lsp_servers()
  local capabilities = build_capabilities()

  -- rust
  vim.lsp.config("rust_analyzer", {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = {
      "Cargo.toml",
      "rust-project.json",
      ".git",
    },
    capabilities = capabilities,
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
  })

  -- C/C++
  vim.lsp.config("clangd", {
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    root_markers = {
      ".clangd",
      ".clang-tidy",
      ".clang-format",
      "compile_commands.json",
      "compile_flags.txt",
      "configure.ac",
      ".git"
    },
    capabilities = capabilities,
    settings = {},
  })

  -- python
  vim.lsp.config("pylsp", {
    cmd = { "pylsp" },
    filetypes = { "python" },
    root_markers = {
      "pyproject.toml",
      "setup.py",
      "setup.cfg",
      "requirements.txt",
      "Pipfile",
      ".git"
    },
    capabilities = capabilities,
    settings = {
      pylsp = {
        plugins = {
          pycodestyle = {
            ignore = { 'W391' },
            maxLineLength = 100,
          },
          pyflakes = {
            enabled = true,
          },
          autopep8 = {
            enabled = true,
          },
          yapf = {
            enabled = false,
          },
          pylint = {
            enabled = false,
          },
        },
      },
    },
  })

  -- lua
  vim.lsp.config("lua_ls", {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = {
      ".luarc.json",
      ".luarc.jsonc",
      ".luacheckrc",
      ".stylua.toml",
      "stylua.toml",
      "selene.toml",
      "selene.yml",
      ".git"
    },
    capabilities = capabilities,
    settings = {
      Lua = {
        workspace = {
          checkThirdParty = false,
        },
        codeLens = {
          enable = true,
        },
        completion = {
          callSnippet = "Replace",
        },
        doc = {
          privateName = { "^_" },
        },
        hint = {
          enable = true,
          setType = false,
          paramType = true,
          paramName = "Disable",
          semicolon = "Disable",
          arrayIndex = "Disable",
        },
      },
    },
  })

  -- go
  vim.lsp.config("gopls", {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = {
      "go.work",
      "go.mod",
      ".git"
    },
    capabilities = capabilities,
    settings = {
      gopls = {
        gofumpt = true,
        codelenses = {
          gc_details = false,
          generate = true,
          regenerate_cgo = true,
          run_govulncheck = true,
          test = true,
          tidy = true,
          upgrade_dependency = true,
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
        directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
        semanticTokens = true,
      },
    },
  })

  -- typescript
  vim.lsp.config("ts_ls", {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx"
    },
    root_markers = {
      "tsconfig.json",
      "package.json",
      "jsconfig.json",
      ".git"
    },
    capabilities = capabilities,
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  })

  -- remember to enable
  vim.lsp.enable("rust_analyzer")
  vim.lsp.enable("clangd")
  vim.lsp.enable("pylsp")
  vim.lsp.enable("lua_ls")
  vim.lsp.enable("gopls")
  vim.lsp.enable("ts_ls")
end

-- autocommands block
local function setup_autocommands()
  -- LSP attach handler
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      local buffer = ev.buf

      -- enable completion triggered by <c-x><c-o>
      vim.bo[buffer].omnifunc = "v:lua.vim.lsp.omnifunc"

      -- inlay hints
      if client and client.supports_method("textDocument/inlayHint") then
        if vim.api.nvim_buf_is_valid(buffer) and vim.bo[buffer].buftype == "" then
          vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
        end
      end

      -- document highlight
      if client and client.supports_method("textDocument/documentHighlight") then
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = buffer,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = buffer,
          callback = vim.lsp.buf.clear_references,
        })
      end
    end,
  })
end

-- analgous to main()
function M.setup()
  if lsp_setup_done then
    return
  end
  lsp_setup_done = true

  setup_diagnostics()
  setup_lsp_servers()
  setup_autocommands()
end

return M
