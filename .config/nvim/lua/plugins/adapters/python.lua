return function(dap)
  -- adapter
  dap.adapters.debugpy = {
    type = "executable",
    command = vim.fn.exepath("python3"),
    args = { "-m", "debugpy.adapter" },
  }

  -- configs
  dap.configurations.python = {
    {
      type = "debugpy",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      pythonPath = function()
        return vim.fn.exepath("python3") or "python"
      end,
    },
  }
end

