-- TODO: slop
return function(dap)
  -- Neovim Lua debugging (nlua)
  dap.adapters.nlua = dap.adapters.nlua or function(callback, config)
    callback({
      type = "server",
      host = config.host or "127.0.0.1",
      port = config.port or 8086,
    })
  end

  dap.configurations.lua = {
    {
      name = "Attach to Neovim",
      type = "nlua",
      request = "attach",
      host = "127.0.0.1",
      port = 8086,
    },
  }
end

