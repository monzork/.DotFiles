syntax on
set number
set mouse=a
set clipboard=unnamed
set showcmd
set ruler
set encoding=utf8
set showmatch
set sw=4
set relativenumber
let mapleader = " "
set laststatus=2
set backspace=2
set guioptions-=T
set guioptions-=L
imap jk <Esc>

"Mapping to reload config
nmap <leader>so :source $HOME\_vimrc<CR>
nmap <leader>w :w <CR>
nmap <leader>q :q <CR>

if has("gui_running")

if has("gui_gtk2")
set guifont=Inconsolata\ 12
elseif has("gui_macvim")
set guifont=Menlo\ Regular:h14
elseif has("gui_win32")
set guifont=Consolas:h11:cANSI
endif
endif

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
"
"
call plug#begin('~/.vim/plugged')
" Temas
Plug 'morhetz/gruvbox'
"IDE
Plug 'easymotion/vim-easymotion'
"Nerdtree
Plug 'preservim/nerdtree'

Plug 'christoomey/vim-tmux-navigator'


Plug 'https://github.com/leafgarland/typescript-vim'

call plug#end()


nmap <Leader>nt :NERDTreeFind<CR>
nmap <Leader>s <Plug>(easymotion-s2)
colorscheme gruvbox
let g:gruvbox_contrast_dark = "hard"





