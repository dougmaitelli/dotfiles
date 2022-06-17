" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive' ], [ 'filename' ] ],
      \   'right': [ [ 'syntastic', 'lineinfo' ], [ 'filetype' ] ]
      \ },
      \ 'component': {
      \   'fugitive': '%{&filetype=="help"?"":exists("*fugitive#head")?"\uE0A0 ".fugitive#head():""}',
      \ },
      \ 'component_visible_condition': {
      \   'fugitive': '(&filetype!="help"&&exists("*fugitive#head") && ""!=fugitive#head())',
      \ },
      \ 'component_expand': {
      \   'syntastic': 'SyntasticStatuslineFlag',
      \ },
      \ 'component_type': {
      \   'syntastic': 'error',
      \ },
      \ 'separator': { 'left': "\uE0B0", 'right': "\uE0B2" },
      \ 'subseparator': { 'left': "\uE0B1", 'right': "\uE0B3" },
      \ }

Plug 'https://github.com/j-tom/vim-old-hope'
Plug 'itchyny/lightline.vim'

Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'vim-syntastic/syntastic'
Plug 'majutsushi/tagbar'
Plug 'leafgarland/typescript-vim'
Plug 'dag/vim-fish'

" Initialize plugin system
call plug#end()

set background=dark
set mouse=a     " Enable mouse usage (all modes)

" Set compatibility to Vim only.
set nocompatible

" Turn on syntax highlighting.
syntax on
color old-hope

" Turn off modelines
set modelines=0

" Automatically wrap text that extends beyond the screen length.
set wrap
" Vim's auto indentation feature does not work properly with text copied from outisde of Vim. Press the <F2> key to toggle paste mode on/off.
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O>:set invpaste paste?<CR>
set pastetoggle=<F2>

set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" Display 5 lines above/below the cursor when scrolling with a mouse.
set scrolloff=5
" Fixes common backspace problems
set backspace=indent,eol,start

" Speed up scrolling in Vim
set ttyfast

" Status bar
set laststatus=2

" Display options
set showmode
set showcmd

" Highlight matching pairs of brackets. Use the '%' character to jump between them.
set matchpairs+=<:>

" Show line numbers
set number

" Encoding
set encoding=utf-8

" Highlight matching search patterns
set hlsearch
" Enable incremental search
set incsearch
" Include matching uppercase words with lowercase search term
set ignorecase
" Include only uppercase words with uppercase search term
set smartcase

" Store info from no more than 100 files at a time, 9999 lines of text, 100kb of data. Useful for copying large amounts of data between files.
set viminfo='100,<9999,s100
