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
-- for some reason lua-ls hates it when i use vim.keymap.set. whatever. *doubles your keybinds*
vim.api.nvim_set_keymap('v', '<Tab>', '>gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-Tab>', '<gv', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<F5>', ":lua require('dap').continue()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<F5>', ":lua require('dap').continue()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F6>', ":lua require('dap').terminate()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<F6>', ":lua require('dap').terminate()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F10>', ":lua require('dap').step_over()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<F10>', ":lua require('dap').step_over()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F11>', ":lua require('dap').step_into()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<F11>', ":lua require('dap').step_into()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F12>', ":lua require('dap').step_out()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<F12>', ":lua require('dap').step_out()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'B', ":lua require('dap').toggle_breakpoint()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'B', ":lua require('dap').toggle_breakpoint()<CR>", { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', '<leader>dl', ':DapRunLast<CR>', { noremap = true, silent = true })

-- toggle extra UI elements
vim.api.nvim_set_keymap('n', '<M-E>', ':lua require("neo-tree")<CR>:Neotree toggle left<CR>',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<M-E>', ':lua require("neo-tree")<CR>:Neotree toggle left<CR>',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-D>', ':lua require("dapui").toggle()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<M-D>', ':lua require("dapui").toggle()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-S>', '`', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<M-S>', '`', { noremap = true, silent = true })

-- lint manually
-- really wish we didn't freak out about vpi.keymap.set ._.
function Toggle_diagnostic()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.diagnostic.is_enabled({ bufnr = bufnr }) then
    vim.diagnostic.enable(false, { bufnr = bufnr })
    print("Diagnostics disabled")
  else
    vim.diagnostic.enable(true, { bufnr = bufnr })
    print("Diagnostics enabled")
  end
end

vim.api.nvim_set_keymap("n", "<M-L>", ":lua Toggle_diagnostic()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<M-L>", ":lua Toggle_diagnostic()<CR>", { noremap = true, silent = true })

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
    -- { "nvim-lspconfig",       enabled = false },
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

-- i set neo-tree to lazy load. this loads it if neovim is called on a dir
-- have and eat cake
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
