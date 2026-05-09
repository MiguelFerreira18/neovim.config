vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.pack.add({
      'https://github.com/folke/todo-comments.nvim',
    })
    require('todo-comments').setup({ signs = false })
  end,
  once = true,
})
