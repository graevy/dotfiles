return {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  config = function()
    local dap = require("dap")

    -- adapters
    dap.adapters.lldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = "codelldb",
        args = { "--port", "${port}" },
      }
    }

    dap.adapters.python = {
      type = 'executable',
      command = 'python',
      args = { '-m', 'debugpy.adapter' },
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

    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = "Launch file",
        program = "${file}",
        pythonPath = function()
          return vim.fn.exepath('python3') or 'python'
        end,
      },
    }

  end,
}
