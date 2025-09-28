return {
  {
    'nvimdev/lspsaga.nvim',
    config = function()
      require('lspsaga').setup {}
      vim.keymap.set('n', 'gp', '<cmd>Lspsaga peek_definition<CR>', { desc = 'Peek definition' })
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      enable = false,
    },
    ui = {
      code_action = '',
    },
  },
}
