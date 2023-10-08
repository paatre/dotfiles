" My own settings
"
" Maintainer:	Teemu Viikeri <teemu.viikeri@haltu.fi>
" Last change:	2023 Aug 5

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

" ==========================
"
" Application level settings
"
" ==========================

" Set Vim to be non Vi-compatible
set nocompatible

" Disable Vim's swap file creation
set noswapfile

" ==========================
"
" Mouse and keyboard settings
"
" ==========================

" Use backspace key
set backspace=indent,eol,start

" Show a few lines of context around the cursor
set scrolloff=5

" ===================
"
" Statusline settings
"
" ===================

" Set statusline format
set statusline=
" Show full file path
set statusline+=%F
set statusline+=\ %l

" Always show statusline
set laststatus=2

" =================
"
" Highligh settings
"
" =================

" Use syntax highlighting
syntax on

" Switch on highlighting and incremental search
set hlsearch
set incsearch

" ================================
"
" Indentation and spacing settings
"
" ================================

" Indenation rules
set autoindent
set smartindent

" Insert spaces instead of tabs
set expandtab

" Sets the number of spaces for a tab
set tabstop=2

" Sets the number of spaces to use when indenting
set shiftwidth=2

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
augroup END

