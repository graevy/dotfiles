return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    name = "neo-tree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          window = {
            width = 30,
          }
        }
      })
    end
  }
}
