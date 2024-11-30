call plug#begin()
Plug 'roxma/nvim-completion-manager'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-surround'
call plug#end()

" Vim config
set shell=/opt/homebrew/bin/fish
:set tags=./tags
set tabstop=2
set expandtab
syntax on
nnoremap j h
nnoremap k j
nnoremap l k
nnoremap ; l
nnoremap K 5j
nnoremap L 5k
nnoremap ' ;
vnoremap j h
vnoremap k j
vnoremap l k
vnoremap ; l
vnoremap K 5j
vnoremap L 5k
vnoremap ' ;


set number
set laststatus=2
set noshowmode
set encoding=utf8
