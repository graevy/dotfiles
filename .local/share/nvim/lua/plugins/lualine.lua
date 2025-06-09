return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("lualine").setup {
        sections = {
          lualine_x = {
            -- Override 'encoding': Don't display if encoding is UTF-8.
            function()
              local ret, _ = (vim.bo.fenc or vim.go.enc):gsub("^utf%-8$", "")
              return ret
            end,
            -- fileformat: Don't display if &ff is unix.
            function()
              local ret, _ = vim.bo.fileformat:gsub("^unix$", "")
              return ret
            end,
            -- 'filetype'
            function()
              local clients = vim.lsp.get_active_clients({ bufnr = 0 })
              if next(clients) == nil then return "" end
              return clients[1].name
            end
          },
        -- lualine_z = { 'location', '%=' },
        },
      }
    end
  }
}

