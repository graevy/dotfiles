-- TODO: slop
return function(dap)
  dap.adapters["pwa-node"] = dap.adapters["pwa-node"] or {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "node",
      args = {
        vim.fn.stdpath("data")
          .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
        "${port}",
      },
    },
  }

  dap.configurations.typescript = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch TS file",
      program = "${file}",
      cwd = "${workspaceFolder}",
      runtimeExecutable = "node",
      sourceMaps = true,
      protocol = "inspector",
      skipFiles = { "<node_internals>/**" },
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach to Node",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
    },
  }

  -- JS shares the same adapter/config
  dap.configurations.javascript = dap.configurations.typescript
end

