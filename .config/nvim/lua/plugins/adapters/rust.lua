return function(dap)
  -- adapter
  dap.adapters.lldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = "codelldb",
      args = { "--port", "${port}" },
    },
  }

  -- configs
    dap.configurations.rust = {
      {
        name = "lldbLaunch",
        type = "lldb",
        request = "launch",
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
        end,
        cwd = vim.fn.getcwd(),
        stopOnEntry = false,
      },
      {
        name = "lldbLaunch with Args",
        type = "lldb",
        request = "launch",
        program = function()
          return vim.split(vim.fn.input("Arguments: ", "", "file"), " ")
        end,
        cwd = vim.fn.getcwd(),
        stopOnEntry = false,
      },
    }


end

