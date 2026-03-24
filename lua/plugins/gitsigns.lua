return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        require('bindings').gitsigns_binds(bufnr)
      end,
    },
  },
}
