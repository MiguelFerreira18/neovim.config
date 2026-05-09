local function setup()
  vim.pack.add({
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-telescope/telescope-ui-select.nvim',
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/nvim-telescope/telescope.nvim',
  })

  if vim.fn.executable 'make' == 1 then vim.pack.add({'https://github.com/nvim-telescope/telescope-fzf-native.nvim'}) end

  require('telescope').setup({
    extensions = {
      ['ui-select'] = { require('telescope.themes').get_dropdown() },
    },
  })
  pcall(require('telescope').load_extension, 'fzf')
  pcall(require('telescope').load_extension, 'ui-select')
  require('bindings').telescope_binds()
end

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    setup()
  end,
  once = true,
})
