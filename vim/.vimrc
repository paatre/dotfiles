" ==========================
"
" Application level settings
"
" ==========================

" Set Vim to be non Vi-compatible
set nocompatible

" Keep 200 lines of command line history
set history=200

" Disable history file creation for netrw
let g:netrw_dirhistmax = 0

" Quite a few people accidentally type "q:" instead of ":q" and get confused
" by the command line window.  Give a hint about how to get out.
augroup vimHints
  au!
  autocmd CmdwinEnter *
  \ echohl Todo |
  \ echo 'You discovered the command-line window! You can close it with ":q".' |
  \ echohl None
augroup END

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
      \ | wincmd p | diffthis
endif

" ==========================
"
" Mouse and keyboard settings
"
" ==========================

" Use backspace key
set backspace=indent,eol,start

" Show a few lines of context around the cursor
set scrolloff=5

" Highlight current line cursor line
set nocursorline

" ===================
"
" Statusline settings
"
" ===================

" Display incomplete commands on the right side of the command line
set showcmd

" Display completion matches in a status line
set wildmenu

" Don't show mode indicator at command line, Airline handles that
set noshowmode

" ================
"
" Folding settings
"
" ================

" Enable markdown folding from ft-markdown-plugin
let g:markdown_folding = 1

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

"Load indentation files: indent.vim
filetype indent on

" Indenation rules
set autoindent
set smartindent

" Insert spaces instead of tabs
set expandtab

" Sets the number of spaces for a tab
set tabstop=2

" Sets the number of spaces to use when indenting
set shiftwidth=2

" =============
"
" Remaps
"
" =============

" Set mapleader to ,
let mapleader = ","

" Map ,cn to :cnext
nnoremap <leader>cn :cnext<Cr>

" Map ,cp to :cprev
nnoremap <leader>cp :cprev<Cr>

" Map Ctrl+P to fuzzy file finder
nnoremap <C-p> :Files<Cr>

" ===============
"
" Plugin settings
"
" ===============

" Automatically install vim-plug if not installed yet
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Initialize vim-plug
call plug#begin('~/.vim/plugged')

" Gruvbox theme
Plug 'morhetz/gruvbox'

" Fugitive
Plug 'tpope/vim-fugitive'

" Fuzzy file finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Pandoc
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

" GitHub Copilot
Plug 'github/copilot.vim'

" End of vim-plug section
call plug#end()

" Gruvbox
autocmd vimenter * ++nested colorscheme gruvbox
set background=dark
