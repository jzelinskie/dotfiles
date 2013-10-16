" vundle bootstrap
set rtp+=$HOME/.vim/bundle/vundle
set nocompatible
filetype off
call vundle#rc()

" vim enhancement
Bundle 'gmarik/vundle'
Bundle 'godlygeek/tabular'
Bundle 'gregsexton/MatchTag'
Bundle 'kien/ctrlp.vim'
Bundle 'majutsushi/tagbar'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'
Bundle 'sjl/gundo.vim'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-unimpaired'
Bundle 'vim-scripts/matchit.zip'
Bundle 'vim-scripts/taglist.vim'

" powerline
Bundle 'bling/vim-airline'
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_theme = 'jellybeans'
let g:airline_theme_patch_func = 'AirlineThemePatch'
function! AirlineThemePatch(palette)
  if g:airline_theme == 'jellybeans'
    let g:airline#themes#jellybeans#palette.visual = g:airline#themes#jellybeans#palette.replace
  endif
endfunction

" colors
Bundle 'jzelinskie/vim-monokai'
Bundle 'Pychimp/vim-luna'

" git
Bundle 'gregsexton/gitv'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-git'
Bundle 'vim-scripts/Gist.vim'

" puppet
Bundle 'rodjek/vim-puppet'

" web
Bundle 'cakebaker/scss-syntax.vim'
Bundle 'evanmiller/nginx-vim-syntax'
Bundle 'hail2u/vim-css3-syntax'
Bundle 'kchmck/vim-coffee-script'
Bundle 'othree/html5.vim'
Bundle 'pangloss/vim-javascript'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-markdown'
Bundle 'chrisbra/csv.vim'
Bundle 'vim-scripts/jQuery'
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
Bundle 'tpope/vim-fireplace'
Bundle 'tpope/vim-classpath'
Bundle 'guns/vim-clojure-static'
let g:paredit_mode = 0

" mac clipboard sync
if system('uname') == 'Darwin\n'
  set clipboard=unnamed
endif

" search options
set ignorecase
set smartcase
set shellslash
set incsearch
set hlsearch
set wildmenu

" visuals
syntax on
filetype plugin indent on
colorscheme monokai
hi TabLineFill ctermfg=bg
set t_Co=256
set hidden
set number
set showmatch
set wrapscan
set ruler
set vb
set lazyredraw
set ttyfast
set showcmd
set showmode
set showfulltag
set laststatus=2
set guioptions-=T "no gui toolbar
set guioptions-=m "no gui menubar
set completeopt-=preview "no autocomplete scratch buffer
set fillchars=vert:·

" functionality
let mapleader = ','
set list listchars=tab:·\ ,eol:¬
set encoding=utf-8
set nobackup
set noswapfile
set shiftround
set backspace=2
set ffs=unix,dos
set virtualedit=all "move anywhere
set history=100
set ts=2 sts=2 sw=2 expandtab
set foldopen=block,insert,jump,mark,percent,quickfix,search,tag,undo
set cpoptions=ces$ "cw-like commands have $ at end
set scrolloff=8 "scroll when 8 lines away
set synmaxcol=2048 "dont color huge lines
set visualbell
set noerrorbells

" map up/down arrow keys to unimpaired commands
nmap <Up> [e
nmap <Down> ]e
vmap <Up> [egv
vmap <Down> ]egv

" map left/right arrow keys to indendation
nmap <Left> <<
nmap <Right> >>
vmap <Left> <gv
vmap <Right> >gv

" toggle pastemode
nmap <silent> <leader>p :set invpaste<CR>:set paste?<CR>

" toggle tagbar
nmap <silent> <leader>o :TagbarToggle<CR>

" toggle nerdtree
nmap <silent> <leader>n :NERDTreeToggle<CR>

" toggle textwrap
nmap <silent> <leader>w :set invwrap<CR>:set wrap?<CR>

" ctrl+l clear search highlight
nnoremap <silent> <C-l> :nohl<CR><C-l>

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

" gofmt on save
autocmd BufWritePre *.go :silent Fmt
