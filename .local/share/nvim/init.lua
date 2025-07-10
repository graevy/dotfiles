-- semantic hell
local opt = vim.opt
local g = vim.g
local fn = vim.fn
local cmd = vim.cmd
local api = vim.api
local diag = vim.diagnostic
local lsp = vim.lsp

-- bootstrap lazy.nvim
local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    fn.getchar()
    os.exit(1)
  end
end
opt.rtp:prepend(lazypath)

-- ===== VIM SETTINGS =====

-- mappings need to be set before loading lazy.nvim
g.mapleader = " "
g.maplocalleader = "\\"

-- show line numbers on the side, have them be relative to cursor
opt.number = true
opt.relativenumber = true

-- ideally i want https://github.com/neovim/neovim/issues/989
-- however i will settle for this for now. disable the limits on window scrolling
opt.scrolloff = 0

-- eagle.nvim likes this to do its automatic hovering. it works great
-- unfortunately it seems to break my ability to seek my cursor via touchscreen in alacritty
-- so eagle.nvim is relegated to keyboard mode :/
-- opt.mousemoveevent = true

-- these are my defaults, but right now i get vim-sleuth to manage them. treesitter handles smartindent
-- opt.tabstop = 2        -- Width of tab character
-- opt.shiftwidth = 2     -- Size of indent
-- opt.softtabstop = 2    -- Number of spaces in tab when editing
-- opt.expandtab = true   -- Convert tabs to spaces
-- opt.smartindent = true -- "Smart" auto-indenting for new lines

-- make backspace delete indents, or, function as you would expect in an IDE
opt.backspace = { "indent", "eol", "start" }

-- disable by default; i have alt+z bound to toggle
opt.wrap = false 

-- when you return to a previous position, preserve the screen orientation
opt.jumpoptions = "stack,view"

-- load neotree if neovim is called on a dir.
-- i configured neotree to only load when its hotkey is pressed (Shift+Alt+E at the moment), so this is convenient
if fn.argc() == 1 and fn.isdirectory(fn.argv(0)) == 1 then
  require("neo-tree")
  cmd("Neotree focus left")
end

-- when a new buffer is done loading,
-- disable spellchecking and diagnostics (linting).
-- lazy.nvim enables spellchecking by default, and it's a git submodule i don't want to deal with
-- diagnostics toggle with a keybind defined below (Shift+Alt+L). lualine displays the error count either way
api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    vim.opt_local.spell = false
    diag.enable(false, { bufnr = 0 })
  end,
})

-- pretty signs <3
-- the e.g. DapBreakpoint aliases are provided by nvim-dap-ui
fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = '', numhl = '' })
 
-- ===== KEYBINDS =====

local nmap = function(mode, keys, func, desc)
  vim.keymap.set(mode, keys, func, { desc = desc, noremap = true, silent = true })
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
nmap({ "n", "v" }, "gd", lsp.buf.definition, "LSP: GoTo Definition")
nmap({ "n", "v" }, "gtd", lsp.buf.type_definition, "LSP: GoTo Type Definition")
nmap({ "n", "v" }, "gr", function() require('fzf-lua').lsp_references() end, "GoTo References")

-- kill the current search highlight after searching
nmap({ "n", "v" }, "<leader>/", ":nohlsearch<CR>", "Clear search highlight")

-- UI toggle keybinds
nmap({ "n", "v" }, "<M-E>", function()
    require('neo-tree')
    cmd("Neotree toggle left")
  end,
  "Toggle Neotree"
)
nmap({ "n", "v" }, "<M-D>", function() require("dapui").toggle() end, "Toggle DAP (Debugging) UI")

-- toggle lint display. lualine still lists warnings/errors/etc. i disable the linting by default down below
nmap({ "n", "v" }, "<M-L>",
  function()
    local bufnr = api.nvim_get_current_buf()
    if diag.is_enabled({ bufnr = bufnr }) then
      diag.enable(false, { bufnr = bufnr })
      print("Diagnostics disabled")
    else
      diag.enable(true, { bufnr = bufnr })
      print("Diagnostics enabled")
    end
  end,
  "Toggle Linting Display"
)

-- (word) wrapping
nmap({ "n", "v" }, "<M-z>", function() cmd("set wrap!") end, "Toggle line-wrapping")

-- LSP keybinds. elected not to attach these to an lsp buffer so they won't error silently
nmap("n", "gD", lsp.buf.declaration, "LSP: GoTo Declaration")
nmap("n", "gI", lsp.buf.implementation, "LSP: GoTo Implementation")
nmap("n", "gK", lsp.buf.signature_help, "LSP: Signature Help")
nmap("i", "<c-k>", lsp.buf.signature_help, "LSP: Signature Help")
nmap("n", "<leader>ca", lsp.buf.code_action, "LSP: Code Action")
nmap("v", "<leader>ca", lsp.buf.code_action, "LSP: Code Action")
nmap("n", "<leader>cr", lsp.buf.rename, "LSP: Rename")
nmap("n", "<leader>cf", function() lsp.buf.format({ timeout_ms = 3000 }) end, "Format Document")
nmap("n", "]d", diag.goto_next, "LSP: Next Diagnostic")
nmap("n", "[d", diag.goto_prev, "LSP: Prev Diagnostic")
nmap("n", "<leader>cd", diag.open_float, "LSP: Line Diagnostics")

-- eagle.nvim keyboard mode hover diagnostics
nmap("n", "K", ":EagleWin<CR>")

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
api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = api.nvim_create_augroup("LazyLSP", { clear = true }),
  once = true,
  callback = function()
    lsp.setup()
  end,
})

