local loaded = false
local function setup()
  if loaded then
    return
  end
  vim.pack.add { 'https://github.com/stevearc/conform.nvim' }
  require('conform').setup {
    notify_on_error = false,
    format_on_save = function(bufnr)
      local enable_filetypes = {}
      if enable_filetypes[vim.bo[bufnr].filetype] then
        return { timeout_ms = 500 }
      else
        return nil
      end
    end,
    default_format_opts = {
      lsp_format = '"fallback"',
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      typescript = { 'prettier' },
      html = { 'prettier' },
      json = { 'prettier' },
      css = { 'prettier' },
      markdown = { 'cbfmt', ' markdown-toc', 'markdownlint' },
    },
  }
  loaded = true
end

vim.keymap.set('n', '<leader>f', function()
  setup()
  require('conform').format { async = true, lsp_format = 'fallback' }
end, { desc = '[F]ormat buffer' })

vim.keymap.set('n', '<leader>W', '<cmd>noautocmd write<CR>', { desc = 'Save without formatting' })
