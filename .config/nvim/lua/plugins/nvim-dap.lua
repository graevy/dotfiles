return {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  config = function()
    local dap = require("dap")

    -- load all adapter modules
    local adapters = vim.fs.find(
      function(name)
        return name:match("%.lua$")
      end,
      {
        path = vim.fn.stdpath("config") .. "/lua/plugins/adapters",
        type = "file",
      }
    )

    for _, path in ipairs(adapters) do
      local mod = path
        :gsub(vim.fn.stdpath("config") .. "/lua/", "")
        :gsub("%.lua$", "")
        :gsub("/", ".")

      require(mod)(dap)
    end
  end,
}

