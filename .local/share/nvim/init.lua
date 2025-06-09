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
vim.opt.backspace = { "indent", "eol", "start" }
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

-- toggle lint display
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

-- LSPs. elected not to attach these to an lsp buffer so they will error loudly instead of silently
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
    -- ~/.local/share/nvim/lua/plugins/, the whole folder (but not subdirs)
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

-- ===== LSP SETUP =====

local lsp = require("lsp")

-- Setup LSP with lazy initialization
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("LazyLSP", { clear = true }),
  once = true,
  callback = function()
    lsp.setup()
  end,
})

-- Add debug command for LSP troubleshooting
vim.api.nvim_create_user_command("LspDebug", function()
  lsp.debug()
end, { desc = "Debug LSP configuration" })

-- Optional: Add command to manually restart LSP
vim.api.nvim_create_user_command("LspRestart", function()
  vim.cmd("LspStop")
  vim.defer_fn(function()
    vim.cmd("edit") -- Re-trigger FileType
  end, 100)
end, { desc = "Restart LSP servers" })

