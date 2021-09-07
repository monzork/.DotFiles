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
set rtp+=~\.fzf
set laststatus=2
set backspace=2
set guioptions-=T
set noswapfile
set guioptions-=L
set encoding=utf-8
set rtp+=~/.fzf
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

Plug 'https://github.com/Quramy/vim-js-pretty-template'

Plug 'https://github.com/leafgarland/typescript-vim'

Plug 'https://github.com/pangloss/vim-javascript'

Plug 'https://github.com/Shougo/vimproc.vim',{'do' :'make'}

Plug 'https://github.com/Quramy/tsuquyomi'

Plug 'https://github.com/ycm-core/YouCompleteMe'

Plug 'https://github.com/vim-syntastic/syntastic'

Plug 'itchyny/vim-gitbranch'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'webastien/vim-ctags'

Plug 'https://github.com/editorconfig/editorconfig-vim'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

Plug '~/.fzf'

Plug 'jeetsukumaran/vim-filesearch'

Plug 'tpope/vim-fugitive'
call plug#end()


nmap <Leader>nt :NERDTreeFind<CR>
nmap <Leader>s <Plug>(easymotion-s2)
colorscheme gruvbox
let g:gruvbox_contrast_dark = "hard"


autocmd FileType typescript syn clear foldBraces
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:tsuquyomi_disable_quickfix = 1
let g:syntastic_typescript_checkers = ['tsuquyomi'] 
