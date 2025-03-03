return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "comment" },
      ignore_install = { "tex", "latex" },
      highlight = {
        enable = true,
        use_languagetree = true,
      },
    },
  },
}
