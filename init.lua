-- leader
vim.g.mapleader = ','

-- mapping functions
local nmap =        function(lhs, rhs) vim.api.nvim_set_keymap('n', lhs, rhs, {}) end
local vmap =        function(lhs, rhs) vim.api.nvim_set_keymap('v', lhs, rhs, {}) end
local snmap =       function(lhs, rhs) vim.api.nvim_set_keymap('n', lhs, rhs, { silent = true}) end
local nnoremap =    function(lhs, rhs) vim.api.nvim_set_keymap('n', lhs, rhs, { noremap = true }) end
local inoremap =    function(lhs, rhs) vim.api.nvim_set_keymap('i', lhs, rhs, { noremap = true }) end
local bufsnoremap = function(lhs, rhs) vim.api.nvim_buf_set_keymap(0, 'n', lhs, rhs, { noremap = true, silent = true }) end
local lspremap =    function(keymap, fn_name) bufsnoremap(keymap, '<cmd>lua vim.lsp.' .. fn_name .. '()<CR>') end

-- exclusions for polyglot
vim.g.polyglot_disabled = {'cue'}

-- Define autocommands in lua
-- https://github.com/neovim/neovim/pull/12378
-- https://github.com/norcalli/nvim_utils/blob/71919c2f05920ed2f9718b4c2e30f8dd5f167194/lua/nvim_utils.lua#L554-L567
function nvim_create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    vim.api.nvim_command('augroup ' .. group_name)
    vim.api.nvim_command('autocmd!')
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
      vim.api.nvim_command(command)
    end
    vim.api.nvim_command('augroup END')
  end
end

-- bootstrap packer
local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])
if not packer_exists then
  local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
  vim.fn.system('git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  vim.cmd [[packadd packer.nvim]]
end

-- packer
local packer = require('packer').startup {
  function(use)
    use { 'bogado/file-line' }
    use { 'ervandew/supertab' }
    use { 'fatih/vim-go' }
    use { 'jjo/vim-cue' }
    use { 'jzelinskie/monokai-soda.vim' }
    use { 'majutsushi/tagbar' }
    use { 'milkypostman/vim-togglelist' }
    use { 'neovim/nvim-lspconfig' }
    use { 'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}}
    use { 'sheerun/vim-polyglot' }
    use { 'tpope/vim-commentary' }
    use { 'tpope/vim-repeat' }
    use { 'tpope/vim-surround' }
    use { 'tpope/vim-unimpaired' }
    use { 'vim-airline/vim-airline' }
    use { 'vim-airline/vim-airline-themes' }
    use { 'vim-scripts/a.vim' }
    use { 'wbthomason/packer.nvim', opt = true }
  end,
}
if not packer_exists then packer.install() end -- install plugins during initial bootstrap

-- language server
local lspcfg = {
  gopls =         { binary = 'gopls',         format_on_save = '*.go'  },
  pyls =          { binary = 'pyls',          format_on_save = '*.py'  },
  pyright =       { binary = 'pyright',       format_on_save = nil,    },
  rust_analyzer = { binary = 'rust-analyzer', format_on_save = '*.rs'  },
  yamlls =        { binary = 'yamlls',        format_on_save = nil     },
}
local lsp = require('lspconfig')
local custom_lsp_attach = function(client)
  local opts = lspcfg[client.name]

  -- autocommplete
  vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- format on save
  if opts['format_on_save'] ~= nil then
    nvim_create_augroups({[client.name] = {{'BufWritePre', opts['format_on_save'], ':lua vim.lsp.buf.formatting_sync(nil, 1000)'}}})
  end

  -- keymaps
  lspremap('gd',    'buf.declaration')
  lspremap('<c-]>', 'buf.definition')
  lspremap('K',     'buf.hover')
  lspremap('gD',    'buf.implementation')
  lspremap('<c-k>', 'buf.signature_help')
  lspremap('1gD',   'buf.type_definition')
  lspremap('gr',    'buf.references')
  lspremap('g0',    'buf.document_symbol')
  lspremap('gW',    'buf.workspace_symbol')
  lspremap('gl',    'diagnostic.show_line_diagnostics')
end

-- only setup lsp clients for binaries that exist
for srv, opts in pairs(lspcfg) do
  if vim.fn.executable(opts['binary']) then lsp[srv].setup { on_attach = custom_lsp_attach } end
end

-- productive arrow keys
nmap('<Up>',    '[e')
vmap('<Up>',    '[egv')
nmap('<Down>',  ']e')
vmap('<Down>',  ']egv')
nmap('<Left>',  '<<')
nmap('<Right>', '>>')
vmap('<Left>',  '<gv')
vmap('<Right>', '>gv')

-- clear hlsearch on redraw
nnoremap('<C-L>', ':nohlsearch<CR><C-L>')

-- telescope
nnoremap('<c-p>', "<cmd>lua require('telescope.builtin').find_files()<cr>")
nnoremap('<c-b>', "<cmd>lua require('telescope.builtin').buffers()<cr>")
nnoremap('<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>")
nnoremap('<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>")
nnoremap('<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<cr>")
nnoremap('<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<cr>")

-- supertab
vim.g.SuperTabDefaultCompletionType = "<c-x><c-o>"
inoremap('<S-Tab>', '<C-v><Tab>')

-- par format
if vim.fn.executable('par') then vim.o.formatprg = 'par -w80' end

-- clipboard
if vim.fn.has('unnamedplus') then vim.o.clipboard = 'unnamedplus' else vim.o.clipboard = 'unnamed' end

-- airline
vim.g.airline_theme = 'monochrome'
vim.g.airline_powerline_fonts = '0'
vim.cmd('let g:airline#extensions#tabline#enabled = 1')
vim.cmd('let g:airline#extensions#tabline#buffer_nr_show = 1')

-- tags
snmap('<leader>o', ':TagbarToggle<CR>')

-- toggle paste and wrap
snmap('<leader>p', ':set invpaste<CR>:set paste?<CR>')
snmap('<leader>w', ':set invwrap<CR>:set wrap?<CR>')

-- add a command to strip trailing whitespace
-- TODO: rewrite in lua
vim.api.nvim_exec(
[[
function! StripTrailingWhitespaces()
  " preparation: save last search, and cursor position.
  let _s=@/
  let l = line('.')
  let c = col('.')
  " do the business:
  %s/\s\+$//e
  " restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
command! -nargs=0 StripWhitespace call StripTrailingWhitespaces()
]], true)

-- misc global opts
settings = {
  'set colorcolumn=80,100',
  'set cursorline',
  'set completeopt-=preview',
  'set cpoptions=ces$',
  'set ffs=unix,dos',
  'set fillchars=vert:·',
  'set foldopen=block,insert,jump,mark,percent,quickfix,search,tag,undo',
  'set guioptions-=T',
  'set guioptions-=m',
  'set hidden',
  'set hlsearch',
  'set ignorecase',
  'set lazyredraw',
  'set list listchars=tab:·\\ ,eol:¬',
  'set nobackup',
  'set noerrorbells',
  'set noshowmode',
  'set noswapfile',
  'set number',
  'set shellslash',
  'set showfulltag',
  'set showmatch',
  'set showmode',
  'set smartcase',
  'set synmaxcol=2048',
  'set t_Co=256',
  'set title',
  'set ts=2 sts=2 sw=2 et ci',
  'set ttyfast',
  'set vb',
  'set virtualedit=all',
  'set visualbell',
  'set wrapscan',
  'set termguicolors',
  'set cpoptions+=_',
  'colorscheme monokai-soda',
}
for _, setting in ipairs(settings) do
  vim.cmd(setting)
end
