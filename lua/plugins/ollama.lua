return {
  {
    'milanglacier/minuet-ai.nvim',
    dependencies = {
      'saghen/blink.cmp',
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('minuet').setup {
        provider = 'openai_fim_compatible',
        n_completions = 1,
        context_window = 512,
        virtualtext = {
          auto_trigger_ft = { '*' },
          keymap = {
            accept = '<Tab>',
          },
        },
        provider_options = {
          openai_fim_compatible = {
            model = 'qwen2.5-coder:7b',
            end_point = 'http://localhost:11434/v1/completions',
            api_key = 'TERM', -- placeholder, not checked
            name = 'Ollama',
            stream = true,
            optional = {
              max_tokens = 56,
              top_p = 0.9,
            },
          },
        },
      }
    end,
  },
}
