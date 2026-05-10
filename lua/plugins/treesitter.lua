vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' }
})
local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'rust', 'go' }
require('nvim-treesitter').install(parsers)

---@param buf integer
---@param language string
local function treesitter_try_attach(buf, language)
  local ok = pcall(vim.treesitter.language.add, language)
  if not ok then return end

  -- Also wrap start in pcall to handle special buffers like TelescopePrompt
  local ok2 = pcall(vim.treesitter.start, buf, language)
  if not ok2 then return end

  local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

  if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
end

local available_parsers = require('nvim-treesitter').get_available()
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf, filetype = args.buf, args.match
    local language = vim.treesitter.language.get_lang(filetype)
    if not language then return end

    local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

    if vim.tbl_contains(installed_parsers, language) then
      -- Parser is installed, attach directly
      treesitter_try_attach(buf, language)
    elseif vim.tbl_contains(available_parsers, language) then
      -- Parser is available but not installed, install then attach
      require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
    else
      -- Try attaching anyway as a fallback
      treesitter_try_attach(buf, language)
    end
  end,
})

-- NOTE: SIMPLE OLD CONFIG
--[[require('nvim-treesitter.install').compilers = { 'gcc', 'cc', 'clang' }
require('nvim-treesitter.config').setup({
  ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'rust', 'go' },
  auto_install = true,
  highlight = {
    enable = false,
    additional_vim_regex_highlighting = { 'ruby' },
  },
  indent = { enable = true, disable = { 'ruby' } },
})
vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})]]--
