return {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "quarto" },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        enabled = false,
        render_modes = true,
		  anti_conceal = {
			  disabled_modes = { 'n', 'v' }
		  },
		  sign = {
			  enabled = false,
		  },
	 },
}

