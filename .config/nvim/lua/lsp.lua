local lsp = vim.lsp

-- shared between each lsp. overwrite merge strat, watch names
local function build_shared_capabilities()
  return vim.tbl_deep_extend(
    "force",
    lsp.protocol.make_client_capabilities(),
    {
      workspace = {
        fileOperations = { didRename = true, willRename = true },
      },
    }
  )
end

-- LSPs must be registered before being enabled. registration is cheap, enabling is not
local function register(server_config)
  server_config.capabilities = vim.tbl_deep_extend(
    "force",
    build_shared_capabilities(),
    server_config.capabilities or {}
  )

  lsp.config(server_config.name, server_config)
  
  -- globally enable the server so that neovim will attach
  -- to any buffer matching filetypes defined in server_config 
  lsp.enable(server_config.name)
end


local M = {}
local setup_done = false
function M.setup()
  if setup_done then return end
  setup_done = true

  -- Discover and register servers
  local files = vim.api.nvim_get_runtime_file("lua/lsps/*.lua", true)
  for _, file in ipairs(files) do
    local mod = file:match("lua/(.-)%.lua$"):gsub("/", ".")
    local ok, config = pcall(require, mod)
    if ok and type(config) == "table" and config.name then
      register(config)
    end
  end
end

return M

