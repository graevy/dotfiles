-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- ===== VIM SETTINGS =====

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- rather than use lazyvim's defaults and selectively disabling plugins i dislike,
-- i import only my subset of lazyvim's defaults, plugins.lazysubset
-- "eventually" i will solidify on tooling and integrate lazysubset directly into plugins
vim.g.lazyvim_check_order = false

vim.opt.number = true
vim.opt.relativenumber = true

-- these are defaults, but ultimately i get vim-sleuth to manage them
vim.opt.tabstop = 2        -- Width of tab character
vim.opt.shiftwidth = 2     -- Size of indent
vim.opt.softtabstop = 2    -- Number of spaces in tab when editing
vim.opt.expandtab = true   -- Convert tabs to spaces

vim.opt.smartindent = true -- Smart auto-indenting for new lines
-- vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.wrap = false

-- ===== KEYBINDS =====

-- Caching this might speed up lua interpretation?
local nmap = function(mode, keys, func, desc)
  vim.keymap.set(mode, keys, func, { desc = desc })
end

-- vscode hotkeys basically
nmap("v", "<Tab>", ">gv", "Indent Block")
nmap("v", "<S-Tab>", "<gv", "Unindent Block")
-- << and >> indent/unindent natively in vim
nmap("n", "<Tab>", ">>", "Indent Line")
nmap("n", "<S-Tab>", "<<", "Unindent Line")

-- debug keybinds
nmap({ "n", "v" }, "<F5>", function() require('dap').continue() end, "LSP: Start/Continue")
nmap({ "n", "v" }, "<F6>", function() require('dap').terminate() end, "LSP: Terminate")
nmap({ "n", "v" }, "<F7>", function() require('dap').run_last() end, "LSP: Run Last")
nmap({ "n", "v" }, "<F10>", function() require('dap').step_over() end, "LSP: Step Over")
nmap({ "n", "v" }, "<F11>", function() require('dap').step_into() end, "LSP: Step Into")
nmap({ "n", "v" }, "<F12>", function() require('dap').step_out() end, "LSP: Step Out")
nmap({ "n", "v" }, "B", function() require('dap').toggle_breakpoint() end, "Toggle Breakpoint")

-- nav keybinds; GOTOs. vim Ctrl+O natively returns to previous cursor position
nmap({ "n", "v" }, "gd", vim.lsp.buf.definition, "LSP: GoTo Definition")
nmap({ "n", "v" }, "gtd", vim.lsp.buf.type_definition, "LSP: GoTo Type Definition")
nmap({ "n", "v" }, "gr", function() require('fzf-lua').lsp_references() end, "GoTo References")

-- UI toggle keybinds
nmap({ "n", "v" }, "<M-E>", function()
    require('neo-tree')
    vim.cmd("Neotree toggle left")
  end,
  "Toggle Neotree"
)
nmap({ "n", "v" }, "<M-D>", function() require("dapui").toggle() end, "Toggle DAP (Debugging) UI")

-- lint manually
nmap({ "n", "v" }, "<M-L>",
  function()
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.diagnostic.is_enabled({ bufnr = bufnr }) then
      vim.diagnostic.enable(false, { bufnr = bufnr })
      print("Diagnostics disabled")
    else
      vim.diagnostic.enable(true, { bufnr = bufnr })
      print("Diagnostics enabled")
    end
  end,
  "Toggle Linting Display"
)

-- wrapping
nmap({ "n", "v" }, "<M-z>", function() vim.cmd("set wrap!") end, "Toggle line-wrapping")

-- LSP keybinds (applied on LspAttach)
local function setup_lsp_keybinds(buffer)
  local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = buffer
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  map("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: GoTo Declaration" })
  map("n", "gI", vim.lsp.buf.implementation, { desc = "LSP: GoTo Implementation" })
  map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
  map("n", "gK", vim.lsp.buf.signature_help, { desc = "LSP: Signature Help" })
  map("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "LSP: Signature Help" })
  map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code Action" })
  map("v", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code Action" })
  map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "LSP: Rename" })
  map("n", "<leader>cf", function()
    vim.lsp.buf.format({ timeout_ms = 3000 })
  end, { desc = "Format Document" })
  map("n", "]d", vim.diagnostic.goto_next, { desc = "LSP: Next Diagnostic" })
  map("n", "[d", vim.diagnostic.goto_prev, { desc = "LSP: Prev Diagnostic" })
  map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "LSP: Line Diagnostics" })
end

-- pretty signs <3
-- the e.g. DapBreakpoint aliases are provided by nvim-dap-ui
vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = '', numhl = '' })

-- ===== LAZY =====

require("lazy").setup({
  spec = {
    -- lualine looks nice, it has ok summary info, not sure it's helpful..maybe for large files?
    -- leaving it for now
    -- { "lualine.nvim",    enabled = false },
    -- my plugins, ~/.local/share/nvim/lua/plugins/
    { import = "plugins" },
  },
  -- install = { colorscheme = { "catppuccin" } },
  change_detection = {
    enabled = true,
    notify = false,
  },
  rocks = {
    enabled = false
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "spellfile",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
})

-- if i want to disable the statusline again, kill lualine, and then uncomment this
-- needs to be disabled after loading lazy i think
-- vim.o.laststatus = 0

vim.cmd.colorscheme("catppuccin")

-- i set neo-tree to load only when its hotkey is pressed. load neotree if neovim is called on a dir. have and eat cake
if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
  require("neo-tree")
  vim.cmd("Neotree focus left")
end

-- disable spellchecking, enabled by default in lazy.nvim
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.spell = false
  end,
})

-- ===== LSP CONFIG =====

-- Native LSP Configuration (lazy-loaded)
local lsp_setup_done = false

local function setup_lsp()
  if lsp_setup_done then return end
  lsp_setup_done = true

  -- Configure diagnostics
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

  -- Build capabilities (simplified for your setup without completion engines)
  local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    {
      workspace = {
        fileOperations = {
          didRename = true,
          willRename = true,
        },
      },
    }
  )

  -- Lua Language Server
  vim.lsp.config("lua_ls", {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml" },
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

  -- Clangd for C/C++
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

  -- Python LSP Server
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
            ignore = {'W391'},
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

  -- Setup LSP keymaps and autocommands
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      local buffer = ev.buf

      -- Enable completion triggered by <c-x><c-o>
      vim.bo[buffer].omnifunc = "v:lua.vim.lsp.omnifunc"

      -- Apply LSP keybinds (defined above with other keybinds)
      setup_lsp_keybinds(buffer)

      -- Inlay hints
      if client and client.supports_method("textDocument/inlayHint") then
        if vim.api.nvim_buf_is_valid(buffer) and vim.bo[buffer].buftype == "" then
          vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
        end
      end

      -- Document highlight
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

  -- Setup autoformat
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("LspFormat", {}),
    callback = function(ev)
      -- Only format if LSP client supports formatting
      local clients = vim.lsp.get_clients({ bufnr = ev.buf })
      for _, client in ipairs(clients) do
        if client.supports_method("textDocument/formatting") then
          vim.lsp.buf.format({
            bufnr = ev.buf,
            timeout_ms = 3000,
            formatting_options = nil,
          })
          break
        end
      end
    end,
  })
end

-- One-shot lazy-load LSP on first file open
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("LazyLSP", { clear = true }),
  once = true,
  callback = setup_lsp,
})

-- ===== LSP CONFIG =====
