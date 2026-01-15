local is_linux = vim.loop.os_uname().sysname:lower() == 'linux'
return {
  'nosduco/remote-sshfs.nvim',
  enabled = is_linux,
  dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
  opts = {
    connections = {},
    mounts = {
      base_dir = vim.fn.expand '~/pdev3',
    },
  },
  config = function(_, opts)
    -- Setup plugin
    require('remote-sshfs').setup(opts)
    require('telescope').load_extension 'remote-sshfs'
    -- Use Neovim's built-in keymap API
    local map = vim.keymap.set

    map('n', '<leader>cts', '<cmd>Telescope remote-sshfs connect<CR>', {
      desc = '[C]onnect [T]o [S]sh',
      noremap = true,
      silent = true,
    })

    map('n', '<leader>dfs', '<cmd>Telescope remote-sshfs disconnect<CR>', {
      desc = '[D]isconnect [S]sh',
      noremap = true,
      silent = true,
    })
  end,
}
