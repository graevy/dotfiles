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

-- replicate vscode tab behavior
vim.api.nvim_set_keymap('v', '<Tab>', '>gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-Tab>', '<gv', { noremap = true, silent = true })

--vim.api.nvim_set_keymap('n', '<leader>D', '', { noremap = true, silent = true })

-- these are nvim-dap-ui provided shortcuts for e.g. ":lua require'dap'.continue()<CR>"
-- for some reason lua-ls hates it when i use vim.keymap.set. whatever
vim.api.nvim_set_keymap('n', '<F5>', ':DapContinue<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F6>', ':DapTerminate<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F10>', ':DapStepOver<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F11>', ':DapStepInto<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F12>', ':DapStepOut<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'B', ':DapToggleBreakpoint<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dl', ':DapRunLast<CR>', { noremap = true, silent = true })

-- toggle extra UI elements
vim.api.nvim_set_keymap('n', '<M-E>', ':Neotree toggle left<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-D>', ':lua require("dapui").toggle()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-S>', '`', { noremap = true, silent = true })

-- pretty signs <3
vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = '', numhl = '' })

require("lazy").setup({
  spec = {
    -- LazyVim + defaults, stored in ~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/plugins/
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins"
    },
    -- default LazyVim plugins I'm disabling
    -- if you know what bufferline does, tell me. i'm serious, please tell me. is it like lualine?
    { "bufferline.nvim",      enabled = false },
    -- mason doesn't play well with nix
    { "mason.nvim",           enabled = false },
    { "mason-lspconfig.nvim", enabled = false },
    -- not sure how much of lspconfig i want to gut
    { "nvim-lspconfig",       enabled = false },
    -- everything below here is just adding to load times afaict
    { "blink.cmp",            enabled = false },
    { "persistence.nvim",     enabled = false },
    { "trouble.nvim",         enabled = false },
    { "mini.ai",              enabled = false },
    { "mini.pairs",           enabled = false },
    { "mini.icons",           enabled = false },
    { "flash.nvim",           enabled = false },
    { "todo-comments.nvim",   enabled = false },
    { "ts-comments.nvim",     enabled = false },
    { "nvim-ts-autotag",      enabled = false },
    { "nvim-treesitter-textobjects", enabled = false },
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

-- disable spellchecking, enabled by default in lazy.nvim
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.spell = false
  end,
})
