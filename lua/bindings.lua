-- lua/bindings.lua
local M = {}

-- Just being lazy
local map = vim.keymap.set

-- Function to open definition in vertical split
function M.goto_def_in_vsplit()
  vim.cmd 'vsplit' -- open vertical split
  vim.lsp.buf.definition() -- jump to definition
end

-- INFO: LSPCONFIG
function M.lspconfig_binds(bufnr)
  local function map_buffer(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    opts.desc = 'LSP:' .. (opts.desc or '???')
    map(mode, l, r, opts)
  end

  map_buffer('n', 'gd', require('telescope.builtin').lsp_definitions, { desc = '[G]oto [D]efinition' })
  map_buffer('n', 'gr', require('telescope.builtin').lsp_references, { desc = '[G]oto [R]eferences' })
  map_buffer('n', 'gI', require('telescope.builtin').lsp_implementations, { desc = '[G]oto [I]mplementation' })
  map_buffer('n', '<leader>D', require('telescope.builtin').lsp_type_definitions, { desc = 'Type [D]efinition' })
  map_buffer('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, { desc = '[D]ocument [S]ymbols' })
  map_buffer('n', '<leader>sS', require('telescope.builtin').lsp_dynamic_workspace_symbols, { desc = '[S]earch [S]ymbols' })
  map_buffer('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })
  map_buffer('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })
  map_buffer('n', 'gD', vim.lsp.buf.declaration, { desc = '[G]oto [D]eclaration' })
  -- map_buffer('K', vim.lsp.buf.hover, 'Hover Documentation')

  if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
    map_buffer('n', '<leader>th', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
    end, { desc = '[T]oggle Inlay [H]ints' })
  end
end

-- INFO: GITSIGNS
function M.gitsigns_binds(bufnr)
  local gitsigns = require 'gitsigns'

  --Only used because of the bufnr
  local function map_buffer(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    map(mode, l, r, opts)
  end

  map_buffer('n', ']c', function()
    if vim.wo.diff then
      vim.cmd.normal { ']c', bang = true }
    else
      gitsigns.nav_hunk 'next'
    end
  end, { desc = 'Jump to next git [c]hange' })

  map_buffer('n', '[c', function()
    if vim.wo.diff then
      vim.cmd.normal { '[c', bang = true }
    else
      gitsigns.nav_hunk 'prev'
    end
  end, { desc = 'Jump to previous git [c]hange' })

  -- Actions
  -- visual mode
  map_buffer('v', '<leader>ghs', function()
    gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
  end, { desc = '[G]it [S]tage hunk' })
  map_buffer('v', '<leader>ghr', function()
    gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
  end, { desc = '[G]it [R]eset hunk' })
  -- normal mode
  map_buffer('n', '<leader>ghs', gitsigns.stage_hunk, { desc = '[G]it [S]tage hunk' })
  map_buffer('n', '<leader>ghr', gitsigns.reset_hunk, { desc = '[G]it [R]eset hunk' })
  map_buffer('n', '<leader>ghS', gitsigns.stage_buffer, { desc = '[G]it [S^]tage buffer' })
  map_buffer('n', '<leader>ghu', gitsigns.stage_hunk, { desc = '[G]it [U]ndo stage hunk' })
  map_buffer('n', '<leader>ghR', gitsigns.reset_buffer, { desc = '[G]it [R^]eset buffer' })
  map_buffer('n', '<leader>ghp', gitsigns.preview_hunk, { desc = '[G]it [P]review hunk' })
  map_buffer('n', '<leader>ghb', gitsigns.blame_line, { desc = '[G]it [B]lame line' })
  map_buffer('n', '<leader>ghd', gitsigns.diffthis, { desc = '[G]it [D]iff against index' })
  map_buffer('n', '<leader>ghD', function()
    gitsigns.diffthis '@'
  end, { desc = '[G]it [D^]iff against last commit' })
  -- Toggles
  map_buffer('n', '<leader>gtb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [B]lame line' })
  map_buffer('n', '<leader>gtD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D^]eleted' })
end

-- INFO: SSHFS
function M.sshfs_binds()
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
end

-- INFO: TELESCOPE
function M.telescope_binds()
  local builtin = require 'telescope.builtin'

  -- Search Features
  map('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  map('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
  map('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
  map('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
  map('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  map('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
  map('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  map('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
  map('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  map('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
  map('n', '<leader>/', function()
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = true,
    })
  end, { desc = '[/] Fuzzily search in current buffer' })

  -- Colorscheme
  map('n', '<leader>sc', function()
    builtin.colorscheme { enable_preview = true }
  end, { desc = '[S]earch [C]olorscheme with live preview' })

  map('n', '<leader>s/', function()
    builtin.live_grep {
      grep_open_files = true,
      prompt_title = 'Live Grep in Open Files',
    }
  end, { desc = '[S]earch [/] in Open Files' })

  -- Search neovim lua files
  map('n', '<leader>sn', function()
    builtin.find_files { cwd = vim.fn.stdpath 'config' }
  end, { desc = '[S]earch [N]eovim files' })
end

-- Set keymaps
function M.setup()
  -- Map it to <leader>vd in normal mode
  map('n', '<leader>vd', M.goto_def_in_vsplit, { noremap = true, silent = true, desc = '[V]ertical [D]efition' })

  vim.api.nvim_set_keymap('n', '<leader>pd', ':Lspsaga peek_definition<CR>', { noremap = true, silent = true, desc = '[P]eek [D]efinition' })
  vim.api.nvim_set_keymap('n', 'gf', ':Lspsaga finder<CR>', { noremap = true, silent = true, desc = '[G]oto function [F]inder' })
  vim.api.nvim_set_keymap('n', 'K', ':Lspsaga hover_doc<CR>', { noremap = true, silent = true, desc = 'Hover Documentation' })

  -- Todos keymaps
  map('n', '<leader>st', ':TodoTelescope<CR>', { noremap = true, silent = true, desc = '[S]earch [T]odo' })

  --Markview keymaps (markdown preview visualizer)
  map('n', '<leader>mt', ':Markview Toggle<CR>', { noremap = true, silent = true, desc = '[M]arkview [T]oggle' })
  map('n', '<leader>ms', ':Markview splitToggle<CR>', { noremap = true, silent = true, desc = '[M]arkview [S]plitview' })
  map('n', '<leader>me', ':Markview Enable<CR>', { noremap = true, silent = true, desc = '[M]arkview [E]nable' })
  map('n', '<leader>md', ':Markview Disable<CR>', { noremap = true, silent = true, desc = '[M]arkview [D]isable' })

  -- quick enter into normal mode
  map('i', 'jj', '<Esc>', { noremap = true, silent = true })
end

return M
