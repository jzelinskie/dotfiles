" leader
let mapleader = ','

" vim-plug: plugin management with lazy loading
set nocompatible
filetype off
call plug#begin('~/.vim/plugged')
Plug 'bling/vim-airline'
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'derekwyatt/vim-scala', { 'for': 'scala' }
Plug 'digitaltoad/vim-jade', { 'for': 'jade' }
Plug 'ekalinin/Dockerfile.vim', { 'for': 'dockerfile' }
Plug 'ervandew/supertab'
Plug 'evanmiller/nginx-vim-syntax', { 'for': 'nginx' }
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'gregsexton/MatchTag'
Plug 'groenewege/vim-less', { 'for': 'less' }
Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }
Plug 'idris-hackers/idris-vim', { 'for': 'idris' }
Plug 'jamessan/vim-gnupg'
Plug 'jzelinskie/molokai'
Plug 'jzelinskie/vim-sensible'
Plug 'kchmck/vim-coffee-script', { 'for': 'coffeescript' }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'majutsushi/tagbar'
Plug 'oscarh/vimerl', { 'for': 'erlang' }
Plug 'othree/html5.vim', { 'for': 'html' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'rodjek/vim-puppet', { 'for': 'puppet' }
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-git', { 'for': 'git' }
Plug 'tpope/vim-haml', { 'for': 'haml' }
Plug 'tpope/vim-markdown', { 'for': 'markdown' }
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'vim-scripts/a.vim'
Plug 'wting/rust.vim', { 'for': 'rust' }
call plug#end()
filetype plugin indent on

" colors
let g:rehash256 = 1
colorscheme molokai

" sync default register to clipboard
if has('unnamedplus')
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif

" speed up ctrl+p with find
if has("unix")
  let g:ctrlp_user_command = "find %s -path '*.git*' -prune -o -type f"
endif

" syntastic
au FileType qf setlocal wrap linebreak
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_go_checkers = ['govet', 'golint', 'gofmt']
let g:syntastic_error_symbol = "✗"
let g:syntastic_warning_symbol = "⚠"
let g:syntastic_enable_signs  = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq   = 0

" airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_theme = 'monochrome'

" python
autocmd FileType python set ts=2 sw=2 et

" vim-go
au FileType go nmap <Leader>i <Plug>(go-info)
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <Leader>gb <Plug>(go-doc-browser)
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap gd <Plug>(go-def)
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)
let g:go_fmt_command = "goimports"

" tags
nmap <silent> <leader>o :TagbarToggle<CR>

" toggle paste and wrap
nmap <silent> <leader>p :set invpaste<CR>:set paste?<CR>
nmap <silent> <leader>w :set invwrap<CR>:set wrap?<CR>

" productive arrow keys
nmap <Up> [e
nmap <Down> ]e
vmap <Up> [egv
vmap <Down> ]egv
nmap <Left> <<
nmap <Right> >>
vmap <Left> <gv
vmap <Right> >gv

" strip trailing whitespace on save
function! <SID>StripTrailingWhitespaces()
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
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" neovim
if has('nvim')
  set nottimeout
  set rtp+=/usr/share/vim
  set rtp+=/usr/share/vim/vim73
  tmap <esc><esc> <c-\><c-n>
endif

" par formatting
set formatprg=par\ -w80

" vim settings
set colorcolumn=80
set completeopt-=preview
set cpoptions=ces$
set ffs=unix,dos
set fillchars=vert:·
set foldopen=block,insert,jump,mark,percent,quickfix,search,tag,undo
set guioptions-=T
set guioptions-=m
set hidden
set hlsearch
set ignorecase
set lazyredraw
set list listchars=tab:·\ ,eol:¬
set nobackup
set noerrorbells
set noshowmode
set noswapfile
set number
set shellslash
set showfulltag
set showmatch
set showmode
set smartcase
set synmaxcol=2048
set t_Co=256
set title
set ts=2 sts=2 sw=2 et ci
set ttyfast
set vb
set virtualedit=all
set visualbell
set wrapscan
