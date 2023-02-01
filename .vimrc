syntax on
set hidden

set number
set autoread
set smartindent
set expandtab
set tabstop=2
set noerrorbells
set mouse=a
set signcolumn=yes
set shiftwidth=2
set clipboard=unnamed
set visualbell
set t_vb=
set showcmd
set ruler
set showmatch
set scrolloff=8
set sw=2
set relativenumber
let mapleader = " "
set laststatus=2
set backspace=2
set guioptions-=T
set noswapfile
set guioptions-=L
set encoding=utf-8
set rtp+=~/.fzf
set nowrap
set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --follow
set shortmess+=c
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
      \'coc-angular',
      \'coc-eslint',
      \'coc-html',
      \'coc-prettier',
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
nmap <leader>so :source $HOME/.vimrc<CR>
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

call plug#begin('~/.vim/plugged')
Plug 'christoomey/vim-tmux-navigator'
Plug 'jiangmiao/auto-pairs'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'puremourning/vimspector'
Plug 'itchyny/vim-gitbranch'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'mvolkmann/vim-tag-comment'
Plug 'zivyangll/git-blame.vim'
Plug 'webastien/vim-ctags'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdcommenter'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
call plug#end()

let NERDTreeShowHidden=1

let $FZF_DEFAULT_OPTS='--reverse'
nmap <leader>gb :!"git branch -vv \| fzf \| awk '{print $1}' \| xargs -r -n 1 git checkout"
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

nnoremap <leader>da :call vimspector#Launch()<CR>
nnoremap <leader>dx :call vimspector#Reset()<CR>

nnoremap <S-k> :call vimspector#StepOut()<CR>
nnoremap <S-l> :call vimspector#StepInto()<CR>
nnoremap <S-j> :call vimspector#StepOver()<CR>

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

nnoremap <leader>d_ :call vimspector#Restart()<CR>
nnoremap <leader>dn :call vimspector#Continue()<CR>
nnoremap <leader>drc :call vimspector#RunToCursor()<CR>
nnoremap <leader>dh :call vimspector#ToogleBreakpoint()<CR>
nnoremap <leader>de :call vimspector#ToogleConditionalBreakpoint()<CR>
nnoremap <leader>dX :call vimspector#ClearBreakpoints()<CR>

nmap <F11> :!start explorer /select,%:p
imap <F11> <Esc><F11>
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
nnoremap <Leader>g :<C-u>call gitblame#echo()<CR>
nmap <Leader>nt :NERDTreeFind<CR>
nmap <Leader>cp :Files<CR>
nmap <Leader>bf :Buffers<CR>
nmap <Leader>vt :vert term<CR>
nmap <Leader>s <Plug>(easymotion-s2)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

colorscheme dracula
