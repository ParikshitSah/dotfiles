" ~/.vimrc - Enhanced configuration with hybrid line numbers and productivity features

" === Basic Settings === {{{
set nocompatible            " Disable vi compatibility
filetype plugin indent on   " Enable filetype detection and indentation
syntax on                   " Enable syntax highlighting
set encoding=utf-8          " Set default encoding
set mouse=a                 " Enable mouse support
set hidden                  " Allow background buffers without saving
set history=1000            " Increase command history
" }}}

" === Line Number Configuration === {{{
set number                  " Show absolute line numbers
set relativenumber          " Show relative line numbers (hybrid mode)
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END
" }}}

" === Indentation & Formatting === {{{
set expandtab               " Use spaces instead of tabs
set tabstop=4               " Visible width of tabs
set softtabstop=4           " Edit as if tabs are 4 spaces
set shiftwidth=4            " Number of spaces to use for autoindent
set autoindent              " Carry indentation between lines
set smartindent             " Better automatic indentation
set nowrap                  " Disable line wrapping
" }}}

" === Search & Navigation === {{{
set incsearch               " Show partial matches while typing
set hlsearch                " Highlight search matches
set ignorecase              " Case-insensitive search
set smartcase               " Case-sensitive when using capital letters
set scrolloff=8             " Keep 8 lines above/below cursor
set sidescrolloff=8         " Keep 8 columns left/right of cursor
" }}}

" === UI Enhancements === {{{
set showcmd                 " Show partial command in status line
set cursorline              " Highlight current line
set cursorcolumn            " Highlight current column
set title                   " Show filename in window title
set wildmenu                " Better command-line completion
set wildmode=longest:full   " Complete longest common match
set showmatch               " Highlight matching brackets
set laststatus=2            " Always show status line
set visualbell              " Use visual bell instead of beeping
" }}}

" === File Management === {{{
set backup                  " Enable backup files
set backupdir=~/.vim/backup " Backup directory
set directory=~/.vim/swap   " Swap file directory
set undofile                " Persistent undo history
set undodir=~/.vim/undo     " Undo file directory
" }}}

" === Key Mappings === {{{
let mapleader=","           " Set leader key to comma

" Toggle relative line numbers
nnoremap <leader>rn :set relativenumber!<CR>

" Clear search highlights
nnoremap <leader><space> :nohlsearch<CR>

" Quick save and quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <leader>l :NERDTree<CR>

" Escape alternatives
inoremap jk <Esc>
inoremap kj <Esc>
" }}}

" === Plugin Management (Optional) ==={{{ 
call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree'       " File explorer
Plug 'vim-airline/vim-airline'  " Status line
Plug 'vim-airline/vim-airline-themes'  
let g:airline_theme='molokai'


Plug 'tpope/vim-commentary'     " Commenting
Plug 'tpope/vim-surround'       " Surround selections
Plug 'airblade/vim-gitgutter'   " Git diff indicators
Plug 'catppuccin/vim', { 'as': 'catppuccin' }

call plug#end()
"}}}
" === Color Scheme === {{{
colorscheme catppuccin_frappe             " Built-in color scheme
" }}}

" vim: foldmethod=marker foldlevel=0

