-- bootstrap lazy.nvim
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

-- mappings need to be set before loading lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.number = true
vim.opt.relativenumber = true

-- these are defaults, but ultimately i get vim-sleuth to manage them
vim.opt.tabstop = 2        -- Width of tab character
vim.opt.shiftwidth = 2     -- Size of indent
vim.opt.softtabstop = 2    -- Number of spaces in tab when editing
vim.opt.expandtab = true   -- Convert tabs to spaces

vim.opt.smartindent = true -- "Smart" auto-indenting for new lines
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.wrap = false -- disable by default; i have alt+z bound to toggle

-- load neotree if neovim is called on a dir.
-- i configured neotree to only load when its hotkey is pressed (Shift+Alt+E at the moment), so this is convenient
if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
  require("neo-tree")
  vim.cmd("Neotree focus left")
end

-- when a new buffer is done loading,
-- disable spellchecking and diagnostics (linting).
-- lazy.nvim enables spellchecking by default, and it's a git submodule i don't want to deal with
-- diagnostics toggle with a keybind defined below (Shift+Alt+L). lualine displays the error count either way
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    vim.opt_local.spell = false
    vim.diagnostic.enable(false, { bufnr = 0 })
  end,
})

-- pretty signs <3
-- the e.g. DapBreakpoint aliases are provided by nvim-dap-ui
vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = '', numhl = '' })

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

-- toggle lint display. lualine still lists warnings/errors/etc. i disable the linting by default down below
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

-- LSP keybinds. elected not to attach these to an lsp buffer so they won't error silently
nmap("n", "gD", vim.lsp.buf.declaration, "LSP: GoTo Declaration")
nmap("n", "gI", vim.lsp.buf.implementation, "LSP: GoTo Implementation")
nmap("n", "K", vim.lsp.buf.hover, "Hover")
nmap("n", "gK", vim.lsp.buf.signature_help, "LSP: Signature Help")
nmap("i", "<c-k>", vim.lsp.buf.signature_help, "LSP: Signature Help")
nmap("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: Code Action")
nmap("v", "<leader>ca", vim.lsp.buf.code_action, "LSP: Code Action")
nmap("n", "<leader>cr", vim.lsp.buf.rename, "LSP: Rename")
nmap("n", "<leader>cf", function() vim.lsp.buf.format({ timeout_ms = 3000 }) end, "Format Document")
nmap("n", "]d", vim.diagnostic.goto_next, "LSP: Next Diagnostic")
nmap("n", "[d", vim.diagnostic.goto_prev, "LSP: Prev Diagnostic")
nmap("n", "<leader>cd", vim.diagnostic.open_float, "LSP: Line Diagnostics")

-- ===== LAZY =====

require("lazy").setup({
  spec = {
    -- ~/.local/share/nvim/lua/plugins/, the whole folder (but not subdirs)
    { import = "plugins" },
  },
  change_detection = {
    enabled = true,
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

-- ===== LSPs =====
local lsp = require("lsp")

-- lazy-init the lsps themselves
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("LazyLSP", { clear = true }),
  once = true,
  callback = function()
    lsp.setup()
  end,
})

