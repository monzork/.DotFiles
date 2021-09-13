syntax on
<<<<<<< HEAD
" confff
=======
" Conlifcto
>>>>>>> 597a5b798e0a20f09ea13d23c73a20c2208b53d8
set tabstop=4 softtabstop=4
set number
set smartindent
set noerrorbells
set mouse=a
set signcolumn=yes
set shiftwidth=4
set clipboard=unnamed
set visualbell
set t_vb=
set showcmd
set ruler
set encoding=utf8
set showmatch
set scrolloff=8
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
set nowrap
set incsearch
imap jk <Esc>

let g:coc_global_extensions = [
			\'coc-markdownlint',
			\'coc-highlight',
			\'coc-explorer',
			\'coc-json',
			\'coc-git',
			\'coc-tsserver',
			\'coc-omnisharp',
			\'coc-prettier',
			\'coc-angular'
			\]

let g:lightline = {
			\ 'active': {
				\   'left': [ [ 'mode', 'paste' ],
				\             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
				\ },
				\ 'component_function': {
					\   'gitbranch': 'gitbranch#name'
					\ },
					\ }
"Mapping to reload config
nmap <leader>so :source $HOME\.vimrc<CR>
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

Plug 'christoomey/vim-tmux-navigator'

Plug 'https://github.com/Quramy/vim-js-pretty-template'

Plug 'https://github.com/leafgarland/typescript-vim'

Plug 'https://github.com/pangloss/vim-javascript'

Plug 'https://github.com/Shougo/vimproc.vim',{'do' :'make'}

Plug 'shmup/vim-sql-syntax'
Plug 'https://github.com/ycm-core/YouCompleteMe'

Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'https://github.com/vim-syntastic/syntastic'

Plug 'itchyny/vim-gitbranch'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'zivyangll/git-blame.vim'
Plug 'webastien/vim-ctags'

Plug 'https://github.com/editorconfig/editorconfig-vim'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'
Plug '~/.fzf'

Plug 'itchyny/lightline.vim'
Plug 'jeetsukumaran/vim-filesearch'

Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'

Plug 'hschne/fzf-git'

call plug#end()

let g:fzf_layout = { 'window': {'width':0.8, 'height':0.8}}
let $FZF_DEFAULT_OPTS='--reverse'
nnoremap <leader>gb :GBranches<CR>
let g:fzf_preview_window = ['right:hidden', 'ctrl-/']
nmap <leader>gj :diffget //3<CR>
nmap <leader>gf :diffget //2<CR>
nmap <leader>gs :G<CR>
nmap <leader>gc :Git commit<CR>

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~ '\s'
endfunction
nmap <F11> :!start explorer /select,%:p
imap <F11> <Esc><F11>
inoremap <silent><expr> <Tab>
			\ pumvisible() ? "\<C-n>" :
			\ <SID>check_back_space() ? "\<Tab>" :
			\ coc#refresh()
nnoremap <Leader>g :<C-u>call gitblame#echo()<CR>
nmap <Leader>nt :NERDTreeFind<CR>

nmap <Leader>s <Plug>(easymotion-s2)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

autocmd BufWritePre * :%s/\s\+$//e

colorscheme dracula
