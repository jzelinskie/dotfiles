" leader
let mapleader = ','

" vundle
set rtp+=$HOME/.vim/bundle/vundle
set nocompatible
filetype off
call vundle#rc()
Bundle 'gmarik/vundle'

" colors
let g:rehash256 = 1
Bundle 'tomasr/molokai'
colorscheme molokai

" mac clipboard sync
if system('uname') == 'Darwin\n'
  set clipboard=unnamedplus
endif

" syntastic
Bundle 'scrooloose/syntastic'
au FileType qf setlocal wrap linebreak
let g:syntastic_auto_loc_list = 1
let g:syntastic_enable_signs  = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq   = 0

" airline
Bundle 'bling/vim-airline'
Bundle 'kien/ctrlp.vim'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_theme = 'monochrome'

" go
Bundle 'jnwhiteh/vim-golang'
Bundle 'nsf/gocode', {'rtp': 'vim/'}
autocmd BufWritePre *.go :silent Fmt

" tags
Bundle 'majutsushi/tagbar'
nmap <silent> <leader>o :TagbarToggle<CR>

" misc runtime files
Bundle 'derekwyatt/vim-scala'
Bundle 'evanmiller/nginx-vim-syntax'
Bundle 'oscarh/vimerl'
Bundle 'rodjek/vim-puppet'
Bundle 'tpope/vim-git'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-markdown'
Bundle 'vim-ruby/vim-ruby'
Bundle 'vim-scripts/django.vim'
Bundle 'wting/rust.vim'

" productivity enhancement
Bundle 'gregsexton/MatchTag'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'vim-scripts/a.vim'

" leader mappings
nmap <silent> <leader>p :set invpaste<CR>:set paste?<CR>
nmap <silent> <leader>w :set invwrap<CR>:set wrap?<CR>

" productive arrow keys
Bundle 'tpope/vim-unimpaired'
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
Bundle 'tpope/vim-sensible'
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
set ts=2 sts=2 sw=2 expandtab
set ttyfast
set vb
set virtualedit=all
set visualbell
set wrapscan
