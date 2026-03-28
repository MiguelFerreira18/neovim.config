return {
  {
    'andweeb/presence.nvim',
    event = 'VeryLazy',
    config = function()
      require('presence').setup {
        workspace_text = 'Working',
        editing_text = function(filename)
          local ft = vim.bo.filetype
          if ft and ft ~= '' then
            return 'Editing some ' .. ft
          else
            return 'Editing a file'
          end
        end,
      }
    end,
  },
}
