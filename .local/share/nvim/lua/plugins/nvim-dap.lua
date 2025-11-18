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
        name = "Debug Package",
        request = "launch",
		  program = "${workspaceFolder}"
      },
      {
        type = "go",
        name = "Debug",
        request = "launch",
        program = "${file}",
      },
      {
        type = "go",
        name = "Attach",
        mode = "local",
        request = "attach",
        processId = require("dap.utils").pick_process,
      },
   }

	-- https://github.com/leoluz/nvim-dap-go
	dap.configurations.delve = {
		 -- the path to the executable dlv which will be used for debugging.
		 -- by default, this is the "dlv" executable on your PATH.
		 path = "dlv",
		 -- time to wait for delve to initialize the debug session.
		 -- default to 20 seconds
		 initialize_timeout_sec = 20,
		 -- a string that defines the port to start delve debugger.
		 -- default to string "${port}" which instructs nvim-dap
		 -- to start the process in a random available port.
		 -- if you set a port in your debug configuration, its value will be
		 -- assigned dynamically.
		 port = "${port}",
		 -- additional args to pass to dlv
		 args = {},
		 -- the build flags that are passed to delve.
		 -- defaults to empty string, but can be used to provide flags
		 -- such as "-tags=unit" to make sure the test suite is
		 -- compiled during debugging, for example.
		 -- passing build flags using args is ineffective, as those are
		 -- ignored by delve in dap mode.
		 -- avaliable ui interactive function to prompt for arguments get_arguments
		 build_flags = {},
		 -- whether the dlv process to be created detached or not. there is
		 -- an issue on delve versions < 1.24.0 for Windows where this needs to be
		 -- set to false, otherwise the dlv server creation will fail.
		 -- avaliable ui interactive function to prompt for build flags: get_build_flags
		 -- detached = vim.fn.has("win32") == 0,
		 -- the current working directory to run dlv from, if other than
		 -- the current working directory.
		 cwd = nil,
	  }

  end,
}

