" leader
let mapleader = ','

" figure out our config directory
let config_dir = has("nvim") ? '~/.config/nvim' : '~/.vim'

" vim-plug: plugin management with lazy loading
" TODO(jzelinskie): investigate dein.vim
set nocompatible
if empty(glob(config_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo ' . config_dir . '/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall
endif
call plug#begin('~/.config/nvim/plugged')
Plug 'bogado/file-line'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'ervandew/supertab'
Plug 'fatih/vim-go', { 'for': 'go', 'tag': 'v1.17' }
Plug 'google/vim-jsonnet', { 'for': 'jsonnet' }
Plug 'jzelinskie/monokai-soda.vim'
Plug 'majutsushi/tagbar'
Plug 'milkypostman/vim-togglelist'
Plug 'racer-rust/vim-racer', { 'for': 'rust' }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'uber/prototool', { 'rtp': 'vim/prototool' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/a.vim'
Plug 'w0rp/ale'
if has('nvim') == 0
  Plug 'tpope/vim-sensible'
endif
call plug#end()

" colors
colorscheme monokai-soda

" ale
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'
let g:ale_lint_on_text_changed = 0
let g:ale_sign_column_always = 1
let g:ale_echo_msg_format = '[%linter%] %s'
let g:ale_linters = {'proto': ['prototool']}

" supertab omni-complete
let g:SuperTabDefaultCompletionType = "<c-x><c-o>"

" sync default register to clipboard
if has('unnamedplus')
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif

" ctrl+p
nmap  <C-B> :CtrlPBuffer<CR>
if executable('rg')
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
else
  let g:ctrlp_user_command = "find %s -path '*.git*' -prune -o -type f"
endif

" airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_theme = 'monochrome'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
  let g:airline_symbols.maxlinenr = ''
endif

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
let g:go_fmt_options = { 'gofmt': '-s' }

" rust.vim
let g:rustfmt_autosave = 1
let g:rustfmt_fail_silently = 1
let g:racer_cmd = $HOME . "/.cargo/bin/racer"
au FileType rust nmap gd <Plug>(rust-def)
au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap <leader>gd <Plug>(rust-doc)

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

" strip trailing whitespace
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
command! -nargs=0 StripWhitespace call <SID>StripTrailingWhitespaces()

" nvim terminal escape
if has('nvim')
  tmap <esc><esc> <c-\><c-n>
endif

" par formatting
if system('par')
  let &formatprg=par\ -w80
endif

" set an undo directory
set undodir=~/.vimundo

" clear hlsearch on redraw
nnoremap <C-L> :nohlsearch<CR><C-L>

" vim settings
set colorcolumn=80
set cursorline
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
if has("nvim")
  set cpoptions+=_
  set termguicolors
endif
