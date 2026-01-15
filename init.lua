vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.smarttab = true

vim.g.have_nerd_font = true

vim.opt.number = true

vim.opt.relativenumber = true

vim.opt.mouse = 'a'

vim.opt.showmode = false

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
  end,
})

vim.keymap.set('n', '<leader>w', vim.cmd.w, { desc = '[W]rite' })
vim.keymap.set('n', '<leader>ge', vim.cmd.Ex, { desc = '[G]oto [E]explorer' })

require('bindings').setup()

vim.opt.breakindent = true
vim.opt.smartindent = true

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes'

vim.opt.updatetime = 250

vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.inccommand = 'split'

vim.opt.cursorline = true

vim.opt.scrolloff = 10

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.api.nvim_set_keymap('n', '<leader>ps', ':Lazy sync<CR>', { noremap = true, silent = true, desc = 'Plugins show' })
vim.api.nvim_set_keymap('n', '<leader>pS', ':Lazy sync<CR>', { noremap = true, silent = true, desc = 'Plugins Sync' })
vim.api.nvim_set_keymap('n', '<leader>pi', ':Lazy install<CR>', { noremap = true, silent = true, desc = 'Plugin install' })
vim.api.nvim_set_keymap('n', '<leader>pa', ':Lazy sync<CR> :MasonUpdate<CR>', { noremap = true, silent = true, desc = 'Update Lazy and Mason' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader>st', ':TodoTelescope<CR>', { desc = '[S]earch [t]odos with Telescope' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  require 'plugins.lsp',
  require 'plugins.treesitter',
  require 'plugins.whichkey',
  require 'plugins.lint',
  require 'plugins.lualine',
  require 'plugins.nvimcmp',
  require 'plugins.telescope',
  require 'plugins.theme',
  require 'plugins.toggleterm',
  require 'plugins.autopairs',
  require 'plugins.comments',
  require 'plugins.conform',
  require 'plugins.discordpresence',
  require 'plugins.gitblame',
  require 'plugins.gitsigns',
  require 'plugins.indentlines',
  require 'plugins.typescript_tools',
  require 'plugins.todo-comments',
  require 'plugins.mini',
  require 'plugins.autotag',
  require 'plugins.remote-sshfs',
  require 'plugins.lspsaga',
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
