vim.pack.add { 'https://github.com/nvim-mini/mini.nvim' }
require('mini.surround').setup({ 
  mappings = {
  around_next = 'aa',
  inside_next = 'ii',
},
n_lines = 500,
})
