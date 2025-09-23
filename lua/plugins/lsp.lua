return {
  {
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      'WhoIsSethDaniel/mason-tool-installer.nvim',

      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      -- Typescript config
      vim.lsp.config('ts_ls', {
        on_attach = on_attach,
        capabilities = capabilities,
        init_options = {
          plugins = { -- I think this was my breakthrough that made it work
            {
              name = '@vue/typescript-plugin',
              location = '/usr/local/lib/node_modules/@vue/language-server',
              languages = { 'vue' },
            },
          },
        },
        filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
      })

      -- Vue_ls (Vue) config
      vim.lsp.config('vue_ls', {})
      local project_lib = vim.fn.getcwd() .. '/node_modules'

      -- Angular config
      vim.lsp.config('angularls', {
        cmd = {
          'ngserver',
          '--stdio',
          '--tsProbeLocations',
          project_lib,
          '--ngProbeLocations',
          project_lib,
        },
        filetypes = { 'typescript', 'html', 'typescriptreact', 'typescript.tsx' },
        root_dir = function(fname)
          return vim.fs.dirname(vim.fs.find({ 'angular.json', 'nx.json', 'package.json' }, { upward = true, path = fname })[1])
        end,
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- Lua config
      vim.lsp.config('lua_ls', {
        capabilities = capabilities,
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      })
      --Enabling LSP servers with new syntax
      vim.lsp.enable 'ts_ls'
      vim.lsp.enable 'vue_ls'
      vim.lsp.enable 'angularls'
      vim.lsp.enable 'lua_ls'

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>sS', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[S]earch [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Change diagnostic symbols in the sign column (gutter)
      if vim.g.have_nerd_font then
        local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
        local diagnostic_signs = {}
        for type, icon in pairs(signs) do
          diagnostic_signs[vim.diagnostic.severity[type]] = icon
        end
        vim.diagnostic.config { signs = { text = diagnostic_signs } }
      end

      -- Setup Mason first
      require('mason').setup()
      local servers = { 'ts_ls', 'vue_ls', 'angularls', 'lua_ls' }
      -- Setup mason-lspconfig with minimal configuration to avoid automatic_enable issues
      require('mason-lspconfig').setup {
        ensure_installed = servers,
      }

      -- Setup mason-tool-installer for additional tools
      local ensure_installed = vim.list_extend(vim.deepcopy(servers), {
        'stylua',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
    end,
  },
}
