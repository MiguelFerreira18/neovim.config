-- lua/bindings.lua
local M = {}

-- Function to open definition in vertical split
function M.goto_def_in_vsplit()
  vim.cmd 'vsplit' -- open vertical split
  vim.lsp.buf.definition() -- jump to definition
end

-- Set keymaps
function M.setup()
  -- Map it to <leader>vd in normal mode
  vim.keymap.set('n', '<leader>vd', M.goto_def_in_vsplit, { noremap = true, silent = true, desc = '[V]ertical [D]efition' })

  vim.api.nvim_set_keymap('n', '<leader>pd', ':Lspsaga peek_definition<CR>', { noremap = true, silent = true, desc = '[P]eek [D]efinition' })
  vim.api.nvim_set_keymap('n', 'gf', ':Lspsaga finder<CR>', { noremap = true, silent = true, desc = '[G]oto function [F]inder' })
  vim.api.nvim_set_keymap('n', 'K', ':Lspsaga hover_doc<CR>', { noremap = true, silent = true, desc = 'Hover Documentation' })

  -- Todos keymaps
  vim.keymap.set('n', '<leader>st', ':TodoTelescope<CR>', { noremap = true, silent = true, desc = '[S]earch [T]odo' })

  --Markview keymaps (markdown preview visualizer)
  vim.keymap.set('n', '<leader>mt', ':Markview Toggle<CR>', { noremap = true, silent = true, desc = '[M]arkview [T]oggle' })
  vim.keymap.set('n', '<leader>ms', ':Markview splitToggle<CR>', { noremap = true, silent = true, desc = '[M]arkview [S]plitview' })
  vim.keymap.set('n', '<leader>me', ':Markview Enable<CR>', { noremap = true, silent = true, desc = '[M]arkview [E]nable' })
  vim.keymap.set('n', '<leader>md', ':Markview Disable<CR>', { noremap = true, silent = true, desc = '[M]arkview [D]isable' })
end

return M
