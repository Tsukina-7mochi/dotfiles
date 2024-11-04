set autoread      " automatically reload file when changed
set clipboard=unnamedplus " enable system clipboard
set completeopt=menuone,noinsert,noselect " completion options
set cursorline    " highlight current line
set expandtab     " use spaces instead of tabs
set incsearch     " enable incremental search
set nocompatible  " disable vi compatibility
set showcmd       " display inputting command
set showtabline=2 " always show tabline
set smartindent   " auto indent
" set termguicolors " enable 24-bit RGB color in terminal

set number        " show line number
set numberwidth=4 " set number width

set ignorecase    " ignore case when searching
set smartcase     " ignore case when searching if there is a capital letter

set nowrap        " disable line wrap

set shiftwidth=4  " set indent size
set tabstop=4     " set tab size

set scrolloff=4
set sidescrolloff=8

scriptencoding utf-8
syntax enable  " enable syntax highlighting


" key config
let mapleader = "\<space>"

inoremap <silent> jj <ESC>
nnoremap <silent> <Esc><Esc> :<C-u>set nohlsearch<Return>
nnoremap <silent> <Leader>n :tabnext<Return>
nnoremap <silent> <Leader>b :tabprevious<Return>

nnoremap ; :
vnoremap ; :
