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
            -- Show up to 2 active LSP clients, with +N if more
            function()
              local bufnr = vim.api.nvim_get_current_buf()
              local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
              if not clients or vim.tbl_isempty(clients) then return "" end

              local max_display = 2
              local names = {}
              for i, client in ipairs(clients) do
                if i <= max_display then
                  table.insert(names, client.name)
                end
              end

              local extra = #clients - max_display
              local suffix = extra > 0 and (" + " .. extra) or ""

              return table.concat(names, ", ") .. suffix
            end,
          },
          -- lualine_z = { 'location', '%=' },
        },
      }
    end
  }
}

