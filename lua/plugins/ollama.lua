vim.pack.add({
  'https://github.com/saghen/blink.lib',
  'https://github.com/saghen/blink.cmp',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/milanglacier/minuet-ai.nvim',
})
require('minuet').setup({
  provider = 'openai_fim_compatible',
  n_completions = 3,
  context_window = 512,
  virtualtext = {
    auto_trigger_ft = { '*' },
    keymap = { accept = '<C-a>', dismiss = '<C-d>' },
  },
  provider_options = {
    openai_fim_compatible = {
      model = 'qwen2.5-coder:7b',
      end_point = 'http://localhost:11434/v1/completions',
      api_key = 'TERM',
      name = 'Ollama',
      stream = true,
    },
  },
})
