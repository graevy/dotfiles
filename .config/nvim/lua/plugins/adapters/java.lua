-- TODO: slop
return function(dap)
  dap.adapters.java = dap.adapters.java or function(callback)
    callback({
      type = "server",
      host = "127.0.0.1",
      port = 5005,
    })
  end

  dap.configurations.java = {
    {
      type = "java",
      request = "attach",
      name = "Attach to JVM",
      hostName = "127.0.0.1",
      port = 5005,
    },
  }
end

