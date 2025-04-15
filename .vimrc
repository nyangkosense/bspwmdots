" Colorscheme 
" colorscheme lunaperche

" Enable syntax highlighting
syntax on

" Enable 24-bit true colors if supported by terminal
 if has('termguicolors')
  set termguicolors
 endif

" Essential settings
set encoding=utf-8          " Use UTF-8 encoding
set number                  " Show line numbers
set relativenumber          " Show relative line numbers
set nowrap                  " Don't wrap lines
set expandtab               " Use spaces instead of tabs
set tabstop=2               " Tab width is 2 spaces
set shiftwidth=2            " Indent with 2 spaces
set softtabstop=2           " Tab key indents by 2 spaces
set smartindent             " Auto indent based on code
set splitright              " Vertical splits go right
set splitbelow              " Horizontal splits go below
set mouse=a                 " Enable mouse
set scrolloff=5             " Keep 5 lines above/below cursor
set lazyredraw              " Faster macros
set showmatch               " Show matching brackets
set incsearch               " Incremental search
set hlsearch                " Highlight search results
set ignorecase              " Ignore case in search
set smartcase               " Unless search contains uppercase
set wildmenu                " Command completion
set wildmode=longest:full,full
set updatetime=300          " Faster update time
set backspace=indent,eol,start  " Sensible backspace
set autoread                " Auto reload changed files
set hidden                  " Allow background buffers
set history=1000            " More history
set showcmd                 " Show command in status line

" Key mappings
let mapleader = " "         " Use space as leader key
nnoremap <leader>w :w<CR>   " Save with leader+w
nnoremap <leader>q :q<CR>   " Quit with leader+q
nnoremap <leader>e :e $MYVIMRC<CR> " Edit vimrc
nnoremap <leader>r :source $MYVIMRC<CR> " Reload vimrc

" Buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" Split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Status line
set laststatus=2
set statusline=%f\ %m%r%h%w%=%l,%c\ %P

" File type specific settings
filetype plugin indent on   " Enable file type detection

" Auto commands
augroup customFileTypes
  autocmd!
  " Set specific file types to use italics
  autocmd FileType markdown,javascript,typescript,json,yaml,html,css,vim hi Comment cterm=italic gui=italic
  autocmd FileType markdown hi markdownItalic cterm=italic gui=italic
augroup END

" Ensure 256 colors in terminal
set t_Co=256

" Enable italic comments by default
highlight Comment cterm=italic gui=italic
