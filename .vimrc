" My configuration file for Vim. Used defaults.vim as a base and expanded from
" there.
"
" Maintainer:	Teemu Viikeri <teemu.viikeri@haltu.fi>
" Last change:	2023 Oct 8

" ==========================
"
" Application level settings
"
" ==========================

" Set Vim to be non Vi-compatible
set nocompatible

" Keep 200 lines of command line history
set history=200

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
set cursorline

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

" Airline statusline
Plug 'vim-airline/vim-airline'

" Fugitive
Plug 'tpope/vim-fugitive'

" Fuzzy file finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" End of vim-plug section
call plug#end()

" Gruvbox
autocmd vimenter * ++nested colorscheme gruvbox
set background=dark

" Airline
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline_section_c = "%F"
let g:airline#extensions#hunks#enabled = 1

" FZF
" let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -l -g ""'

