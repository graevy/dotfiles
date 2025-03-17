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


-- right now, i only really ever use the filetree navigation or the debug window, so this is helpful
-- search is probably best done in a floating window with telescope or fzf-lua?
local dapui_open = false -- Track dap-ui state manually
vim.keymap.set("n", "<leader>d", function()
  if dapui_open then
    require("dapui").close()
    vim.cmd("Neotree focus left")
    dapui_open = false
  else
    vim.cmd("Neotree close left")
    require("dapui").open()
    dapui_open = true
  end
end, { noremap = true, silent = true, desc = "Toggle between DAP UI and Neo-tree" })

-- these are nvim-dap-ui provided shortcuts for e.g. ":lua require'dap'.continue()<CR>"
vim.api.nvim_set_keymap("n", "<F5>", ":DapContinue<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<F6>", ":DapTerminate<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<F10>", ":DapStepOver<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "B", ":DapToggleBreakpoint<CR>", { noremap = true, silent = true })

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
    { "blink.cmp",            enabled = false },
    { "bufferline.nvim",      enabled = false },
    { "mini.pairs",           enabled = false },
    -- mason doesn't play well with nix
    { "mason.nvim",           enabled = false },
    { "mason-lspconfig.nvim", enabled = false },
    --{ "nvim-lspconfig",       enabled = false },
    { "trouble.nvim",         enabled = false },
    -- my personal plugins, in ~/.local/share/nvim/lua/plugins/
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

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.spell = false
  end,
})
