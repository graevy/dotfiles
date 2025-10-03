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

    dap.adapters.debugpy = {
      type = 'executable',
      command = vim.fn.exepath("python3"),
      args = { '-m', 'debugpy.adapter' },
    }

    dap.adapters.go = {
      type = "server",
      port = "${port}",
      executable = {
        command = "dlv",
        args = { "dap", "-l", "127.0.0.1:${port}" },
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

    dap.configurations.python = {
      {
        type = 'debugpy',
        request = 'launch',
        name = "Launch file",
        program = "${file}",
        pythonPath = function()
          return vim.fn.exepath('python3') or 'python'
        end,
      },
    }

    dap.configurations.go = {
      {
        type = "go",
        name = "Debug",
        request = "launch",
        program = "${file}",
      },
      {
        type = "go",
        name = "Debug Package",
        request = "launch",
        program = "${fileDirname}",
      },
      {
        type = "go",
        name = "Attach",
        mode = "local",
        request = "attach",
        processId = require("dap.utils").pick_process,
      },
    }

  end,
}
