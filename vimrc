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
  set clipboard=unnamed
endif

" powerline
Bundle 'bling/vim-airline'
Bundle 'kien/ctrlp.vim'
Bundle 'scrooloose/syntastic'
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_theme = 'monochrome'

" tags
Bundle 'majutsushi/tagbar'
nmap <silent> <leader>o :TagbarToggle<CR>

" git
Bundle 'airblade/vim-gitgutter'
Bundle 'gregsexton/gitv'
Bundle 'mattn/gist-vim'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-git'
let g:gitgutter_enabled = 0
let g:gitgutter_highlight_lines = 1
nmap <silent> <leader>g :GitGutterToggle<CR>

" puppet
Bundle 'rodjek/vim-puppet'

" web
Bundle 'cakebaker/scss-syntax.vim'
Bundle 'chrisbra/csv.vim'
Bundle 'evanmiller/nginx-vim-syntax'
Bundle 'gregsexton/MatchTag'
Bundle 'hail2u/vim-css3-syntax'
Bundle 'kchmck/vim-coffee-script'
Bundle 'othree/html5.vim'
Bundle 'pangloss/vim-javascript'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-markdown'
autocmd FileType html setlocal indentkeys-=*<Return>
let g:html_indent_inctags = 'html,body,head,tbody'
let g:html_indent_script1 = 'inc'
let g:html_indent_style1 = 'inc'

" scala
Bundle 'derekwyatt/vim-scala'

" erlang
Bundle 'oscarh/vimerl'

" go
Bundle 'Blackrush/vim-gocode'
autocmd BufWritePre *.go :silent Fmt

" rust
Bundle 'wting/rust.vim'

" ruby
Bundle 'vim-ruby/vim-ruby'
Bundle 'tpope/vim-rails'

" C/C++
Bundle 'vim-scripts/a.vim'

" python
Bundle 'vim-scripts/django.vim'

" clojure
Bundle 'guns/vim-clojure-static'
Bundle 'tpope/vim-classpath'
Bundle 'tpope/vim-fireplace'
let g:paredit_mode = 0

" productivity enhancement
Bundle 'godlygeek/tabular'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'sjl/gundo.vim'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
nmap <silent> <leader>n :NERDTreeToggle<CR>
nmap <silent> <leader>p :set invpaste<CR>:set paste?<CR>
nmap <silent> <leader>w :set invwrap<CR>:set wrap?<CR>
nnoremap <silent> <C-l> :nohl<CR><C-l>

" unimpaired arrow keys
Bundle 'tpope/vim-unimpaired'
nmap <Up> [e
nmap <Down> ]e
vmap <Up> [egv
vmap <Down> ]egv

" identation arrow keys
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

" vim
syntax on
filetype plugin indent on
hi TabLineFill ctermfg=bg
set backspace=2
set completeopt-=preview
set cpoptions=ces$
set encoding=utf-8
set ffs=unix,dos
set fillchars=vert:·
set foldopen=block,insert,jump,mark,percent,quickfix,search,tag,undo
set guioptions-=T
set guioptions-=m
set hidden
set history=100
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set lazyredraw
set list listchars=tab:·\ ,eol:¬
set nobackup
set noerrorbells
set noshowmode
set noswapfile
set number
set ruler
set scrolloff=8
set shellslash
set shiftround
set showcmd
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
set wildmenu
set wrapscan
