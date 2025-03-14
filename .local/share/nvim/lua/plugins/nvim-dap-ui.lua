return {
  "mfussenegger/nvim-dap",
  "rcarriga/nvim-dap-ui",
  dependencies = { "nvim-neotest/nvim-nio" },
  config = function()
    require("dapui").setup()
  end
}

