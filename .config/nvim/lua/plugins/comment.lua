return {
  "echasnovski/mini.comment",
  event = "VeryLazy",
  opts = {},
}

-- for an embedded typescript edge case
-- return {
--   "echasnovski/mini.comment",
--   event = "VeryLazy",
--   dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
--   opts = {
--     options = {
--       custom_commentstring = function()
--         return require("ts_context_commentstring.internal").calculate_commentstring()
--           or vim.bo.commentstring
--       end,
--     },
--   },
-- }
