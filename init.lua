-- leader
vim.g.mapleader = ','

-- mapping functions
function nmap(lhs, rhs) vim.api.nvim_set_keymap('n', lhs, rhs, {}) end
function vmap(lhs, rhs) vim.api.nvim_set_keymap('v', lhs, rhs, {}) end
function xmap(lhs, rhs) vim.api.nvim_set_keymap('v', lhs, rhs, {}) end
function snmap(lhs, rhs) vim.api.nvim_set_keymap('n', lhs, rhs, { silent = true}) end
function nnoremap(lhs, rhs) vim.api.nvim_set_keymap('n', lhs, rhs, { noremap = true }) end
function inoremap(lhs, rhs) vim.api.nvim_set_keymap('i', lhs, rhs, { noremap = true }) end
function bufsnoremap(lhs, rhs) vim.api.nvim_buf_set_keymap(0, 'n', lhs, rhs, { noremap = true, silent = true }) end
function lspremap(keymap, fn_name) bufsnoremap(keymap, '<cmd>lua vim.lsp.' .. fn_name .. '()<CR>') end

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

-- misc global opts
local settings = {
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
}
for _, setting in ipairs(settings) do vim.cmd(setting) end

-- clear hlsearch on redraw
nnoremap('<C-L>', ':nohlsearch<CR><C-L>')

-- clipboard
if vim.fn.has('unnamedplus') then vim.o.clipboard = 'unnamedplus' else vim.o.clipboard = 'unnamed' end

-- toggle paste and wrap
snmap('<leader>p', ':set invpaste<CR>:set paste?<CR>')
snmap('<leader>w', ':set invwrap<CR>:set wrap?<CR>')

-- strip trailing whitespace
nnoremap('<leader>sws', ':%s/\\s\\+$//e<CR>')

-- bootstrap packer
function exclude_on_bootstrap(fn) if not packer_bootstrap then return fn end end
local packer_install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(packer_install_path)) > 0 then
  packer_bootstrap = true
  vim.fn.system('git clone --depth 1 https://github.com/wbthomason/packer.nvim ' .. packer_install_path)
  vim.cmd [[packadd packer.nvim]]
end

-- packer
return require('packer').startup(function(use)
  use {
    'bogado/file-line',
    'folke/which-key.nvim',
    'jjo/vim-cue',
    'milkypostman/vim-togglelist',
    'ray-x/lsp_signature.nvim',
    'tpope/vim-commentary',
    'tpope/vim-repeat',
    'tpope/vim-surround',
    'vim-scripts/a.vim',
    'wbthomason/packer.nvim',

    {
      'tpope/vim-unimpaired',
      config = exclude_on_bootstrap(function()
        nmap('<Up>',    '[e')
        vmap('<Up>',    '[egv')
        nmap('<Down>',  ']e')
        vmap('<Down>',  ']egv')
        nmap('<Left>',  '<<')
        nmap('<Right>', '>>')
        vmap('<Left>',  '<gv')
        vmap('<Right>', '>gv')
      end),
    },
    {
      'jzelinskie/monokai-soda.vim',
      requires = 'tjdevries/colorbuddy.vim',
      config = exclude_on_bootstrap(function()
        vim.cmd('colorscheme monokai-soda')
      end),
    },
    {
      'norcalli/nvim-colorizer.lua',
      config = exclude_on_bootstrap(function()
        require('colorizer').setup()
      end),
    },
    {
      'fatih/vim-go',
      config = exclude_on_bootstrap(function()
        vim.g.go_echo_go_info = 0 -- https://github.com/fatih/vim-go/issues/2904#issuecomment-637102187
        vim.g.go_fmt_command = 'gopls'
        vim.g.go_gopls_gofumpt = 1
      end),
    },
    {
      'junegunn/vim-easy-align',
      config = exclude_on_bootstrap(function()
        xmap('ga', '<Plug>(EasyAlign)')
        nmap('ga', '<Plug>(EasyAlign)')
      end),
    },
    {
      'nvim-treesitter/nvim-treesitter',
      config = exclude_on_bootstrap(function()
        require('nvim-treesitter.configs').setup({
          ensure_installed = "maintained",
          highlight = { enable = true },
        })
      end),
    },
    {
      'vim-airline/vim-airline-themes',
      requires = 'vim-airline/vim-airline',
      config = exclude_on_bootstrap(function()
        vim.g.airline_theme = 'monochrome'
        vim.g.airline_powerline_fonts = '0'
        vim.cmd('let g:airline#extensions#tabline#enabled = 1')
        vim.cmd('let g:airline#extensions#tabline#buffer_nr_show = 1')
      end),
    },
    {
      'ervandew/supertab',
      config = exclude_on_bootstrap(function()
        inoremap('<S-Tab>', '<C-v><Tab>')
        vim.g.SuperTabDefaultCompletionType = "<c-x><c-o>"
      end),
    },
    {
      'majutsushi/tagbar',
      config = exclude_on_bootstrap(function()
        snmap('<leader>o', ':TagbarToggle<CR>')
      end),
    },
    {
      'nvim-telescope/telescope.nvim',
      requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
      config = exclude_on_bootstrap(function()
        nnoremap('<c-p>', "<cmd>lua require('telescope.builtin').find_files()<cr>")
        nnoremap('<c-b>', "<cmd>lua require('telescope.builtin').buffers()<cr>")
        nnoremap('<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>")
        nnoremap('<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>")
        nnoremap('<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<cr>")
        nnoremap('<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<cr>")
      end),
    },
    {
      'neovim/nvim-lspconfig',
      config = exclude_on_bootstrap(function()
        local lspcfg = {
          gopls =            {binary = 'gopls',                    format_on_save = nil         },
          golangci_lint_ls = {binary = 'golangci-lint-langserver', format_on_save = nil         },
          pylsp =            {binary = 'pylsp',                    format_on_save = '*.py'      },
          pyright =          {binary = 'pyright',                  format_on_save = nil         },
          rust_analyzer =    {binary = 'rust-analyzer',            format_on_save = '*.rs'      },
          clojure_lsp =      {binary = 'clojure-lsp',              format_on_save = '*.clj'     },
          yamlls =           {binary = 'yamlls',                   format_on_save = nil         },
          bashls =           {binary = 'bash-language-server',     format_on_save = nil         },
          dockerls =         {binary = 'docker-langserver',        format_on_save = 'Dockerfile'},
        }
        local lsp_keymaps = {
          {capability = 'declaration',      mapping = 'gd',    command = 'buf.declaration'     },
          {capability = 'implementation',   mapping = 'gD',    command = 'buf.implementation'  },
          {capability = 'goto_definition',  mapping = '<c-]>', command = 'buf.definition'      },
          {capability = 'type_definition',  mapping = '1gD',   command = 'buf.type_definition' },
          {capability = 'hover',            mapping = 'K',     command = 'buf.hover'           },
          {capability = 'signature_help',   mapping = '<c-k>', command = 'buf.signature_help'  },
          {capability = 'find_references',  mapping = 'gr',    command = 'buf.references'      },
          {capability = 'document_symbol',  mapping = 'g0',    command = 'buf.document_symbol' },
          {capability = 'workspace_symbol', mapping = 'gW',    command = 'buf.workspace_symbol'},
        }
        local custom_lsp_attach = function(client)
          require('lsp_signature').on_attach { hint_enable = false }
          local opts = lspcfg[client.name]

          -- autocomplete
          vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

          -- format on save
          if opts['format_on_save'] ~= nil then
            nvim_create_augroups({[client.name] = {{'BufWritePre', opts['format_on_save'], ':lua vim.lsp.buf.formatting_sync(nil, 1000)'}}})
          end

          -- conditional keymaps
          for _, keymap in ipairs(lsp_keymaps) do
            if client.resolved_capabilities[keymap.capability] then
              lspremap(keymap.mapping, keymap.command)
            end
          end

          -- unconditional keymaps
          lspremap('gl', 'diagnostic.show_line_diagnostics')
        end

        -- only setup lsp clients for binaries that exist
        local lsp = require('lspconfig')
        for srv, opts in pairs(lspcfg) do
          if vim.fn.executable(opts['binary']) then lsp[srv].setup({ on_attach = custom_lsp_attach }) end
        end
      end),
    },
  }

  -- bootstrap installation on first run
  if packer_bootstrap then
    require('packer').sync()
  end
end)
