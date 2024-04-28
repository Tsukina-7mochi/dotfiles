" disable vi compatibility
set nocompatible

" display inputting command
set showcmd

" enable syntax highlighting
syntax enable



" key config
inoremap <silent> jj <ESC>
let mapleader = " i"



" plugins

" install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'catppuccin/nvim', { 'as': 'catppuccin' }

call plug#end()



" color scheme
colorscheme "catppuccin-frappe"

