set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=/opt/homebrew/opt/fzf/bin/fzf
call vundle#begin()


" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'christoomey/vim-tmux-navigator'  
Plugin 'liuchengxu/vim-clap'
Plugin 'itchyny/lightline.vim'
Plugin 'sheerun/vim-polyglot'
Plugin 'dense-analysis/ale'
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'
Plugin 'tpope/vim-surround'
Plugin 'preservim/nerdtree'
Plugin 'ryanoasis/vim-devicons'

" All of your Plugins must be added before the following line
call vundle#end()            " required
" filetype plugin indent on    " required
" " To ignore plugin indent changes, instead use:
" "filetype plugin on
" "
" " Brief help
" " :PluginList       - lists configured plugins
" " :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" " :PluginSearch foo - searches for foo; append `!` to refresh local cache
" " :PluginClean      - confirms removal of unused plugins; append `!` to
" auto-approve removal

" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" ALE configurations
let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\}
" Linter configuration
let g:ale_linters = {
  \   'javascript': ['eslint'],
  \}
" This flag can be set to 0 to disable linting when the buffer is entered.
let g:ale_lint_on_enter = 0
let g:ale_fixers = {'*': ['remove_trailing_lines', 'trim_whitespace'], 'javascript': ['prettier-eslint', 'eslint']}
let g:ale_fix_on_save = 0
let g:ale_enabled = 1

" ALE hotkeys
nmap <F6> <Plug>(ale_fix)
nmap <F10> <Plug>(ale_toggle)

" NERDTree hotkeys
nmap <F1> <Plug>(nerdtree_toggle)

" Vim config
set shell=/opt/homebrew/bin/fish

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

nnoremap <C-t> :Files<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>h :History<CR>

set number
set laststatus=2
set noshowmode
set encoding=utf8
