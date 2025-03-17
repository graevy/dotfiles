return {
  "rcarriga/nvim-dap-ui",
  dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  config = function()
    require("dapui").setup({
      layouts = {
        {
          elements = {
            { id = "scopes",      size = 0.25 },
            { id = "breakpoints", size = 0.15 },
            { id = "stacks",      size = 0.15 },
            { id = "watches",     size = 0.15 },
          },
          size = 30, -- Adjust panel width
          position = "left",
        },
        {
          elements = {
            "repl",
            "console",
          },
          size = 10, -- Adjust height
          position = "bottom",
        },
      }
    })
  end
}
