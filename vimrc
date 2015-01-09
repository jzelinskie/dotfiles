" leader
let mapleader = ','

" vundle
set nocompatible
filetype off
set rtp+=$HOME/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'bling/vim-airline'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'cespare/vim-toml'
Plugin 'derekwyatt/vim-scala'
Plugin 'digitaltoad/vim-jade'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'evanmiller/nginx-vim-syntax'
Plugin 'fatih/vim-go'
Plugin 'gmarik/vundle'
Plugin 'gregsexton/MatchTag'
Plugin 'groenewege/vim-less'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'idris-hackers/idris-vim'
Plugin 'kchmck/vim-coffee-script'
Plugin 'kien/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'oscarh/vimerl'
Plugin 'othree/html5.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'rodjek/vim-puppet'
Plugin 'scrooloose/syntastic'
Plugin 'tomasr/molokai'
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-git'
Plugin 'tpope/vim-haml'
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'vim-ruby/vim-ruby'
Plugin 'vim-scripts/a.vim'
Plugin 'vim-scripts/django.vim'
Plugin 'wting/rust.vim'
call vundle#end()
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

" syntastic
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
au FileType qf setlocal wrap linebreak
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_go_checkers = ['govet', 'golint', 'gotype']
let g:syntastic_auto_loc_list = 1
let g:syntastic_enable_signs  = 1
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
let g:go_fmt_command = "gofmt"

" tags
nmap <silent> <leader>o :TagbarToggle<CR>

" leader mappings
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
