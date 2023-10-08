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

" Disable Vim's swap file creation
set noswapfile

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

" ===================
"
" Statusline settings
"
" ===================

" Always show statusline
set laststatus=2

" Set statusline format
set statusline=
" Show full file path
set statusline+=%F
" Show line and column number
set statusline+=\ %l,%c

" Display incomplete commands on the right side of the statusline
set showcmd

" Display completion matches in a status line
set wildmenu

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

" Load indentation files: indent.vim
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

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!
  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
augroup END

" ===============
"
" Plugin settings
"
" ===============

" Load plugin files: ftplugin.vim
filetype plugin on

