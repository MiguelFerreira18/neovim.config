vim.pack.add { 'https://github.com/andweeb/presence.nvim' }
require('presence').setup {
  auto_update = true,
  neovim_image_text = 'The One True Text Editor',
  main_image = 'neovim',
  show_time = true,
  editing_text = function(filename)
    local ft = vim.bo.filetype
    if ft and ft ~= '' then
      return 'Editing some ' .. ft
    else
      return 'Editing a file'
    end
  end,
  file_explorer_text = 'Browsing %s',
  git_commit_text = 'Committing changes',
  reading_text = 'Reading %s',
  workspace_text = 'Working',
}
