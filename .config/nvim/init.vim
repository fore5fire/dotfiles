set nocompatible
filetype off
" set the runtime path to include Vundle and initialize
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin("~/.config/nvim/bundle")
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'tpope/vim-fugitive'
Plugin 'skywind3000/asyncrun.vim'
Plugin '907th/vim-auto-save'
Plugin 'fatih/vim-go'
Plugin 'Shougo/deoplete.nvim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Setup deoplete
call deoplete#enable()
" Use deoplete with vim-go
call deoplete#custom#option('omni_patterns', { 'go': '[^. */t]/./w*' })

set number
set title
set clipboard=unnamedplus
syntax on
set tabstop=4
set softtabstop=4
set shiftwidth=0
set expandtab                     " use spaces, not tab characters
set showmatch                     " show bracket matches
set ignorecase                    " ignore case in search
set hlsearch                      " highlight all search matches
set incsearch                     " show search results as I type
set smartcase                     " pay attention to case when caps are used
set ruler                         " show row and column in footer
set autochdir
set colorcolumn=81,101,121
set nowrap

nnoremap !d :AsyncRun alacritty&<CR>

let g:auto_save = 1
