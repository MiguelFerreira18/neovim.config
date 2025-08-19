return {
  {
    'andweeb/presence.nvim',
    event = 'VeryLazy',
   config = function()
      require("presence").setup({
        workspace_text = "Working"
      })
    end
  },
}
