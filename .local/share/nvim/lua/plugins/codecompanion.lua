return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  event = "VeryLazy",
  opts = {
	 strategies = {
		chat = {
		  adapter = "anthropic",
		  model = "claude-sonnet-4-20250514"
		},
	 },
	 -- opts.opts
    opts = {
      log_level = "DEBUG", -- or "TRACE"
    },
  },
}

