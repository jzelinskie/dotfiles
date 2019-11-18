" leader
let mapleader = ','

" figure out our config directory
let config_dir = has("nvim") ? '~/.config/nvim' : '~/.vim'

" setup minpac, a vim-plug clone that uses native vim packages
set nocompatible
if empty(glob(config_dir . '/autoload/plugpac.vim'))
  silent execute '!git clone https://github.com/k-takata/minpac.git ' . config_dir . '/pack/minpac/opt/minpac'
  silent execute '!curl -fLo ' . config_dir . '/autoload/plugpac.vim --create-dirs https://raw.githubusercontent.com/bennyyip/plugpac.vim/master/plugpac.vim'
  autocmd VimEnter * PackInstall
endif
" enable plugins
call plugpac#begin()
Pack 'andrewstuart/vim-kubernetes', { 'for': 'yaml' }
Pack 'bogado/file-line'
Pack 'ctrlpvim/ctrlp.vim'
Pack 'dense-analysis/ale'
Pack 'elmcast/elm-vim', { 'for': 'elm' }
Pack 'ervandew/supertab'
Pack 'fatih/vim-go', { 'for': 'go', 'tag': 'v1.20' }
Pack 'google/vim-jsonnet', { 'for': 'jsonnet' }
Pack 'jzelinskie/monokai-soda.vim'
Pack 'k-takata/minpac', { 'type': 'opt' }
Pack 'majutsushi/tagbar'
Pack 'milkypostman/vim-togglelist'
Pack 'racer-rust/vim-racer', { 'for': 'rust' }
Pack 'rust-lang/rust.vim', { 'for': 'rust' }
Pack 'sheerun/vim-polyglot'
Pack 'tpope/vim-commentary'
Pack 'tpope/vim-repeat'
Pack 'tpope/vim-surround'
Pack 'tpope/vim-unimpaired'
Pack 'vim-airline/vim-airline'
Pack 'vim-airline/vim-airline-themes'
Pack 'vim-scripts/a.vim'
if has('nvim') == 0
  Pack 'tpope/vim-sensible'
endif
call plugpac#end()

" colors
colorscheme monokai-soda

" ale
nmap gd <Plug>(ale_go_to_definition)
let g:ale_lint_on_text_changed = 1
let g:ale_sign_column_always = 1
let g:ale_echo_msg_format = '[%linter%] %s'
let g:ale_set_highlights = 0
if has('macunix')
  let g:ale_sign_error = '✗'
  let g:ale_sign_warning = '⚠'
endif

" supertab omni-complete
let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
inoremap <S-Tab> <C-v><Tab>

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
let g:airline_powerline_fonts = 0
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
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
if executable('golangci-lint')
  let g:go_metalinter_command='golangci-lint'
endif

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
