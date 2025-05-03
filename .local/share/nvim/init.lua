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

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Caching this might speed up lua interpretation?
local nmap = function(mode, keys, func, desc)
  if desc then
    desc = 'LSP: ' .. desc
  end

  vim.keymap.set(mode, keys, func, { desc = desc })
end

-- vscode hotkeys basically
nmap("v", "<Tab>", ">gv", "Indent Block")
nmap("v", "<S-Tab>", "<gv", "Unindent Block")
-- << and >> indent/unindent natively in vim
nmap("n", "<Tab>", ">>", "Indent Line")
nmap("n", "<S-Tab>", "<<", "Unindent Line")

nmap({ "n", "v" }, "<F5>", function() require('dap').continue() end, "Start/Continue")
nmap({ "n", "v" }, "<F6>", function() require('dap').terminate() end, "Terminate")
nmap({ "n", "v" }, "<F7>", function() require('dap').run_last() end, "Run Last")
nmap({ "n", "v" }, "<F10>", function() require('dap').step_over() end, "Step Over")
nmap({ "n", "v" }, "<F11>", function() require('dap').step_into() end, "Step Into")
nmap({ "n", "v" }, "<F12>", function() require('dap').step_out() end, "Step Out")
nmap({ "n", "v" }, "B", function() require('dap').toggle_breakpoint() end, "Toggle Breakpoint")

-- GOTOs. vim Ctrl+O natively returns to previous cursor position
nmap({ "n", "v" }, "gd", vim.lsp.buf.definition, "GoTo Definition")
nmap({ "n", "v" }, "gtd", vim.lsp.buf.type_definition, "GoTo Type Definition")
nmap({ "n", "v" }, "gr", function() require('fzf-lua').lsp_references() end, "GoTo References")

-- toggle extra UI elements
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

-- pretty signs <3
-- the e.g. DapBreakpoint aliases are provided by nvim-dap-ui
vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = '', numhl = '' })

-- rather than use lazyvim's defaults and selectively disabling plugins i dislike,
-- i import only my subset of lazyvim's defaults, plugins.lazysubset
-- "eventually" i will solidify on tooling and integrate lazysubset directly into plugins
vim.g.lazyvim_check_order = false

require("lazy").setup({
  spec = {
    {
      "LazyVim/LazyVim",
      import = "plugins.lazysubset"
    },
    -- not sure how much of lspconfig i want to gut
    -- it's getting pseudo-deprecated in nvim 11 with vim.lsp.config being added
    -- { "nvim-lspconfig",  enabled = false },
    -- lualine looks nice, it has ok summary info, not sure it's helpful..maybe for large files?
    { "lualine.nvim",    enabled = false },
    -- my plugins, ~/.local/share/nvim/lua/plugins/
    { import = "plugins" },
  },
  install = { colorscheme = { "catppuccin" } },
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

-- i set neo-tree to lazy load. this loads it if neovim is called on a dir. have and eat cake?
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

-- not getting anything out of the statusline so i'm killing it
-- also needs to be disabled after loading lazy i think
-- maybe the progress percentage was useful?
-- tracking errors while linting is disabled was also nice
vim.o.laststatus = 0
