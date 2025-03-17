return {
  "mfussenegger/nvim-dap",
  config = function()
    local dap = require("dap")
    dap.adapters.gdb = {
      type = "executable",
      command = "gdb",
      args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
      name = "gdb"
    }
    dap.adapters.lldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = "codelldb",
        args = { "--port", "${port}" },
      }
    }

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
      {
        name = "gdbLaunch",
        type = "gdb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
        end,
        cwd = vim.fn.getcwd(),
        stopOnEntry = false,
      },
      {
        name = "gdbLaunch with Args",
        type = "gdb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
        end,
        cwd = vim.fn.getcwd(),
        stopOnEntry = false,
        args = function()
          return vim.split(vim.fn.input("Arguments: ", "", "file"), " ")
        end,
      },
      {
        name = "Select and attach to process",
        type = "gdb",
        request = "attach",
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        pid = function()
          local name = vim.fn.input('Executable name (filter): ')
          return require("dap.utils").pick_process({ filter = name })
        end,
        cwd = '${workspaceFolder}'
      },
      {
        name = 'Attach to gdbserver :1234',
        type = 'gdb',
        request = 'attach',
        target = 'localhost:1234',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}'
      },
    }

    -- this is bad because of the target/debug thang, gotta fix
    dap.configurations.c = dap.configurations.rust
    dap.configurations.cpp = dap.configurations.rust
  end,
}
