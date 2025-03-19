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

-- vscode hotkeys basically
vim.api.nvim_set_keymap('v', '<Tab>', '>gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-Tab>', '<gv', { noremap = true, silent = true })

vim.keymap.set({ "n", "v" }, "<F5>", function() require('dap').continue() end)
vim.keymap.set({ "n", "v" }, "<F6>", function() require('dap').terminate() end)
vim.keymap.set({ "n", "v" }, "<F7>", function() require('dap').run_last() end)
vim.keymap.set({ "n", "v" }, "<F10>", function() require('dap').step_over() end)
vim.keymap.set({ "n", "v" }, "<F11>", function() require('dap').step_into() end)
vim.keymap.set({ "n", "v" }, "<F12>", function() require('dap').step_out() end)
vim.keymap.set({ "n", "v" }, "B", function() require('dap').toggle_breakpoint() end)

-- GOTOs. vim Ctrl+O natively returns to previous cursor position
vim.keymap.set({ "n", "v" }, "gd", vim.lsp.buf.definition, { desc = "goto definition" })
vim.keymap.set({ "n", "v" }, "gtd", vim.lsp.buf.type_definition, { desc = "goto type definition" })
vim.keymap.set({ "n", "v" }, "gr", function() require('fzf-lua').lsp_references() end, { desc = "goto references" })

-- toggle extra UI elements
vim.keymap.set({ "n", "v" }, "<M-E>", function()
  require('neo-tree')
  vim.cmd("Neotree toggle left")
end)
vim.keymap.set({ "n", "v" }, "<M-D>", function() require("dapui").toggle() end)

-- lint manually
vim.keymap.set({ "n", "v" }, "<M-L>", function()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.diagnostic.is_enabled({ bufnr = bufnr }) then
    vim.diagnostic.enable(false, { bufnr = bufnr })
    print("Diagnostics disabled")
  else
    vim.diagnostic.enable(true, { bufnr = bufnr })
    print("Diagnostics enabled")
  end
end)

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
