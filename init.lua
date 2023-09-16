-- leader
vim.g.mapleader = ','

-- mapping functions
function nmap(lhs, rhs) vim.api.nvim_set_keymap('n', lhs, rhs, {}) end
function vmap(lhs, rhs) vim.api.nvim_set_keymap('v', lhs, rhs, {}) end
function xmap(lhs, rhs) vim.api.nvim_set_keymap('v', lhs, rhs, {}) end
function snmap(lhs, rhs) vim.api.nvim_set_keymap('n', lhs, rhs, { silent = true}) end
function nnoremap(lhs, rhs) vim.api.nvim_set_keymap('n', lhs, rhs, { noremap = true }) end

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

-- packer
local function load_packer_config(bootstrap)
  local function exclude_on_bootstrap(fn) if not bootstrap then return fn end end
  return require('packer').startup(function(use)
    use {
      'bogado/file-line',
      'folke/which-key.nvim',
      'jjo/vim-cue',
      'milkypostman/vim-togglelist',
      'ray-x/lsp_signature.nvim',
      'tpope/vim-commentary',
      'tpope/vim-repeat',
      'tpope/vim-sleuth',
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
          vim.g.go_doc_keywordprg_enabled = 0
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
            -- ensure_installed = "all",
            ignore_install = { "phpdoc" },
            disable = { "phpdoc" },
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
          vim.keymap.set('i', '<S-Tab>', '<C-v><Tab>', { noremap=true })
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
        requires = {{'nvim-lua/plenary.nvim'}},
        config = exclude_on_bootstrap(function()
          local builtin = require('telescope.builtin')
          vim.keymap.set('n', '<c-p>', builtin.find_files, {})
          vim.keymap.set('n', '<c-b>', builtin.buffers, {})
          vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
          vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
          vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
          vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        end),
      },
      {
        'neovim/nvim-lspconfig',
        config = exclude_on_bootstrap(function()
          local lspcfg = {
            gopls = { bin='gopls', fmt={'*.go'}, settings={ gopls={ gofumpt=true } } },
            clojure_lsp      = { bin='clojure-lsp',              fmt={'*.clj'}       },
            dockerls         = { bin='docker-langserver',        fmt={'Dockerfile'}  },
            pylsp            = { bin='pylsp',                    fmt={'*.py'}        },
            rust_analyzer    = { bin='rust-analyzer',            fmt={'*.rs'}        },
            bashls           = { bin='bash-language-server',     fmt={}              },
            golangci_lint_ls = { bin='golangci-lint-langserver', fmt={}              },
            pyright          = { bin='pyright',                  fmt={}              },
            yamlls           = { bin='yamlls',                   fmt={}              },
          }
          local lsp_keymaps = {
            { cap='declaration',      map='gd',    cmd=vim.lsp.buf.declaration      },
            { cap='implementation',   map='gD',    cmd=vim.lsp.buf.implementation   },
            { cap='goto_definition',  map='<c-]>', cmd=vim.lsp.buf.definition       },
            { cap='type_definition',  map='1gD',   cmd=vim.lsp.buf.type_definition  },
            { cap='hover',            map='K',     cmd=vim.lsp.buf.hover            },
            { cap='signature_help',   map='<c-k>', cmd=vim.lsp.buf.signature_help   },
            { cap='find_references',  map='gr',    cmd=vim.lsp.buf.references       },
            { cap='document_symbol',  map='g0',    cmd=vim.lsp.buf.document_symbol  },
            { cap='workspace_symbol', map='gW',    cmd=vim.lsp.buf.workspace_symbol },
          }
          local custom_lsp_attach = function(client, bufnr)
            require('lsp_signature').on_attach { hint_enable = false }
            local opts = lspcfg[client.name]

            -- autocomplete
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

            -- format on save
            vim.api.nvim_create_autocmd({'BufWritePre'}, {
              pattern = opts['fmt'],
              callback = function(args) vim.lsp.buf.formatting_sync(nil, 1000) end
            })

            -- conditional keymaps
            local keymap_opts = { noremap=true, silent=true, buffer=bufnr }
            for _, keymap in ipairs(lsp_keymaps) do
              if client.server_capabilities[keymap.cap] then
                vim.keymap.set('n', keymap.map, keymap.cmd, keymap_opts)
              end
            end
            -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, keymap_opts)

            -- unconditional keymaps
            vim.keymap.set('n', 'gl', vim.diagnostic.open_float, keymap_opts)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev,  keymap_opts)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next,  keymap_opts)
          end

          -- only setup lsp clients for binaries that exist
          local lsp = require('lspconfig')
          for srv, opts in pairs(lspcfg) do
            if vim.fn.executable(opts['bin']) then lsp[srv].setup({ on_attach = custom_lsp_attach, settings=opts['settings'] }) end
          end
        end),
      },
    }
  end)
end

-- bootstrap packer
local packer_install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(packer_install_path)) > 0 then
  vim.fn.system('git clone --depth 1 https://github.com/wbthomason/packer.nvim ' .. packer_install_path)
  vim.cmd [[packadd packer.nvim]]
  load_packer_config(true)
  require('packer').sync()
  -- vim.cmd [[autocmd User PackerComplete ++once lua load_packer_config(false)]]
else
  load_packer_config(false)
end
